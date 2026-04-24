import os 
os.environ['PINECONE_API_KEY']='pcsk_3dKbud_2gk7JkppW6ga9bzSYNupFWG2vi8VtJq2D2dumWEp6KLyxU7tBGdS7UKGQC1MHvU' 
from pinecone import Pinecone 
pc = Pinecone(api_key=os.environ['PINECONE_API_KEY']) 
idx = pc.Index('cortex-rag') 
print(idx.describe_index_stats()) 
