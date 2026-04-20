"""
Helper utilities for the LLM Student Assistant.
"""

import json
import re
from typing import Any, Dict, List, Optional
from utils.logger import logger


def extract_json(text: str) -> Optional[Dict[str, Any]]:
    """
    Extract JSON from text, handling cases where JSON is wrapped in markdown.
    
    Args:
        text: Text potentially containing JSON
        
    Returns:
        Parsed JSON dictionary or None
    """
    try:
        # Try to find JSON within code blocks
        json_match = re.search(r'```(?:json)?\s*({.*?})\s*```', text, re.DOTALL)
        if json_match:
            return json.loads(json_match.group(1))
        
        # Try direct JSON parsing
        return json.loads(text)
    except (json.JSONDecodeError, AttributeError) as e:
        logger.warning(f"Failed to extract JSON from text: {e}")
        return None


def format_response(data: Dict[str, Any]) -> str:
    """
    Format response data into a readable string.
    
    Args:
        data: Response data dictionary
        
    Returns:
        Formatted response string
    """
    if not data:
        return "No data to display."
    
    lines = []
    for key, value in data.items():
        if isinstance(value, list):
            lines.append(f"{key}:")
            for item in value:
                if isinstance(item, dict):
                    for k, v in item.items():
                        lines.append(f"  - {k}: {v}")
                else:
                    lines.append(f"  - {item}")
        elif isinstance(value, dict):
            lines.append(f"{key}:")
            for k, v in value.items():
                lines.append(f"  {k}: {v}")
        else:
            lines.append(f"{key}: {value}")
    
    return "\n".join(lines)


def clean_text(text: str) -> str:
    """
    Clean text by removing extra whitespace and normalizing.
    
    Args:
        text: Raw text
        
    Returns:
        Cleaned text
    """
    # Remove extra whitespace
    text = re.sub(r'\s+', ' ', text)
    # Remove leading/trailing whitespace
    return text.strip()


def truncate_text(text: str, max_length: int = 5000) -> str:
    """
    Truncate text to maximum length.
    
    Args:
        text: Text to truncate
        max_length: Maximum length
        
    Returns:
        Truncated text
    """
    if len(text) > max_length:
        return text[:max_length] + "..."
    return text


def sanitize_sql(query: str) -> str:
    """
    Basic SQL sanitization (not a replacement for parameterized queries).
    
    Args:
        query: SQL query string
        
    Returns:
        Sanitized query
    """
    # Remove dangerous keywords (basic protection)
    dangerous_patterns = [
        r';\s*DROP',
        r';\s*DELETE',
        r';\s*TRUNCATE',
        r';\s*ALTER',
    ]
    
    sanitized = query
    for pattern in dangerous_patterns:
        if re.search(pattern, query, re.IGNORECASE):
            logger.warning(f"Potentially dangerous SQL pattern detected: {pattern}")
            sanitized = re.sub(pattern, '', query, flags=re.IGNORECASE)
    
    return sanitized
