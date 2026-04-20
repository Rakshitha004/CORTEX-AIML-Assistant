"""
Simple caching utility for query results.
"""

import time
import hashlib
from typing import Any, Dict, Optional
from utils.logger import logger
from config.settings import CACHE_ENABLED, CACHE_TTL


class Cache:
    """Simple in-memory cache with TTL support."""
    
    def __init__(self, enabled: bool = CACHE_ENABLED, ttl: int = CACHE_TTL):
        """
        Initialize cache.
        
        Args:
            enabled: Whether caching is enabled
            ttl: Time to live for cache entries in seconds
        """
        self.enabled = enabled
        self.ttl = ttl
        self.store: Dict[str, Dict[str, Any]] = {}
    
    def _hash_key(self, key: str) -> str:
        """Generate hash of key."""
        return hashlib.md5(key.encode()).hexdigest()
    
    def get(self, key: str) -> Optional[Any]:
        """
        Get value from cache.
        
        Args:
            key: Cache key
            
        Returns:
            Cached value or None
        """
        if not self.enabled:
            return None
        
        hash_key = self._hash_key(key)
        
        if hash_key in self.store:
            entry = self.store[hash_key]
            # Check if entry has expired
            if time.time() - entry['timestamp'] < self.ttl:
                logger.debug(f"Cache hit for key: {key}")
                return entry['value']
            else:
                # Remove expired entry
                del self.store[hash_key]
                logger.debug(f"Cache entry expired for key: {key}")
        
        return None
    
    def set(self, key: str, value: Any) -> None:
        """
        Set value in cache.
        
        Args:
            key: Cache key
            value: Value to cache
        """
        if not self.enabled:
            return
        
        hash_key = self._hash_key(key)
        self.store[hash_key] = {
            'value': value,
            'timestamp': time.time()
        }
        logger.debug(f"Cache set for key: {key}")
    
    def clear(self) -> None:
        """Clear all cache entries."""
        self.store.clear()
        logger.info("Cache cleared")
    
    def cleanup_expired(self) -> None:
        """Remove all expired entries."""
        current_time = time.time()
        expired_keys = [
            key for key, entry in self.store.items()
            if current_time - entry['timestamp'] >= self.ttl
        ]
        for key in expired_keys:
            del self.store[key]
        logger.debug(f"Cleaned up {len(expired_keys)} expired cache entries")


# Global cache instance
_cache = Cache()


def get_cached(key: str) -> Optional[Any]:
    """Get value from global cache."""
    return _cache.get(key)


def set_cached(key: str, value: Any) -> None:
    """Set value in global cache."""
    _cache.set(key, value)


def clear_cache() -> None:
    """Clear global cache."""
    _cache.clear()
