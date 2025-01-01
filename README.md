# Real Estate NFT Smart Contract

This Clarity 2.0 smart contract is designed to manage real estate assets as non-fungible tokens (NFTs) on the Stacks blockchain. It provides functionality for minting, burning, and managing metadata for NFTs, enabling a secure and efficient way to digitize property ownership.

## Features

1. **Mint Tokens**  
   - Mint individual tokens with unique URIs.  
   - Batch-mint up to 100 tokens in a single transaction.  

2. **Burn Tokens**  
   - Safely burn tokens to mark them as inactive or removed.

3. **Metadata Management**  
   - Update metadata for existing tokens.  
   - Retrieve metadata and ownership information.

4. **Security**  
   - Enforces strict permissions for token minting and metadata updates.  
   - Ensures tokens cannot be burned twice or reused.

## Contract Structure

### Constants
- Defines error codes for better readability and debugging.  
- Includes a limit for maximum batch minting (`max-batch-amount`).

### NFT Declaration
- Declares `real-estate-token` as a non-fungible token.

### Data Variables and Maps
- `current-token-id`: Tracks the latest token ID.  
- `token-metadata`: Stores metadata for each token.  
- `burned-status`: Tracks whether a token has been burned.  
- `batch-info`: Stores batch details for token minting.

### Functions

#### Public Functions
- **`mint-token(uri)`**: Mints a new token with the provided URI.  
- **`batch-mint-tokens(uris)`**: Mints multiple tokens in a single call.  
- **`burn-token(token-id)`**: Burns the token with the given ID.  
- **`update-token-metadata(token-id, new-uri)`**: Updates metadata for a specific token.

#### Read-Only Functions
- **`get-token-metadata(token-id)`**: Fetches metadata for a token.  
- **`get-token-owner(token-id)`**: Retrieves the owner of a token.  
- **`get-last-token-id()`**: Returns the last minted token ID.  
- **`is-token-burned(token-id)`**: Checks if a token has been burned.  
- **`get-token-batch(start-id, batch-count)`**: Retrieves a batch of tokens starting from a specific ID.

#### Private Functions
- Helpers for validating URIs, token ownership, and batch minting.

### Installation and Deployment

1. Clone this repository.
   ```bash
   git clone https://github.com/your-repo/real-estate-nft-contract.git
   ```
2. Deploy the contract using your preferred Stacks development environment.
3. Interact with the contract using Clarity functions.

### Error Codes

| Code       | Description                       |
|------------|-----------------------------------|
| `u100`     | Permission denied.               |
| `u101`     | Invalid owner.                   |
| `u102`     | Token already exists.            |
| `u103`     | Token not found.                 |
| `u104`     | Invalid URI.                     |
| `u105`     | Token burn rejected.             |
| `u106`     | Token already burned.            |
| `u107`     | Owner mismatch.                  |
| `u108`     | Invalid batch count.             |
| `u109`     | Batch minting failed.            |

### License

This project is licensed under the MIT License. See the LICENSE file for details.

### Contributing

Contributions are welcome! Please fork this repository and submit a pull request.
