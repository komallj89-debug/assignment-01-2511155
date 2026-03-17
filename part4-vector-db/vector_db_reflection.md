## Vector DB Use Case

A traditional keyword-based database search would **not** suffice for a law firm's contract search system, and here is why.

Keyword search works by matching exact terms. If a lawyer types "termination clauses," a traditional system will only return sections that contain the literal words "termination" and "clauses." However, legal contracts use varied language to express the same concepts — the same idea might appear as "conditions for dissolution," "grounds for early exit," "circumstances warranting contract end," or "events of default leading to termination." A keyword search would miss all of these unless the lawyer happens to use the exact phrase the contract drafter used. In a 500-page contract with thousands of clauses, this is a practical failure.

A vector database solves this through semantic similarity. Here is how it would work in this system: first, the 500-page contract is split into smaller chunks (paragraphs or sections). Each chunk is passed through an embedding model — such as a sentence-transformer — which converts the text into a high-dimensional numerical vector that captures its meaning, not just its words. These vectors are stored in a vector database such as Pinecone, Weaviate, or Chroma.

When a lawyer asks "What are the termination clauses?", that query is also converted into a vector using the same embedding model. The vector database then performs a nearest-neighbour search to find the contract chunks whose vectors are closest in meaning to the query — regardless of exact wording. A section titled "Conditions for Early Dissolution" would score highly because its semantic meaning is close to the query's meaning.

The practical benefit is that lawyers can ask natural questions in plain English and receive relevant contract sections based on intent and meaning, dramatically reducing contract review time and the risk of overlooking critical clauses.
