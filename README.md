
# Baguette Royale — A French-Themed NFT Collection

**Baguette Royale** is a unique, French-inspired non-fungible token (NFT) collection built on the Clarity smart contract language for the Stacks blockchain. Each NFT represents a beautifully crafted artisan baguette, complete with a variety of crusts, fillings, flavors, and traits that make each piece one-of-a-kind.

---

## 🌟 Features

- 🥖 **Mintable NFTs**: Users can mint baguettes directly from the contract.
- 🌿 **Randomized Attributes**: Each baguette has randomly generated attributes such as crust type, filling, flavor, length, and rarity.
- ✅ **Trait System**: Organic, gluten-free, and seeded traits with configurable rarity.
- 🔐 **Whitelist Support**: Discounted mint price for whitelisted users.
- 🎨 **Reveal Functionality**: Optional delayed metadata reveal.
- 💸 **Royalty Support**: Configurable royalty percentage on secondary sales.
- 👑 **Admin Controls**: Mint pricing, whitelist management, royalties, and metadata URI can be updated by the contract owner.

---

## 📦 Contract Overview

### NFT Definition
```clojure
(define-non-fungible-token le-baguette uint)
```

### Token Metadata
Stored in two separate maps:
- **token-attributes**: crust, filling, flavor, length (in cm), rarity
- **token-traits**: is-organic, is-gluten-free, has-seeds

---

## 🚀 Minting Baguettes

### `mint-baguette`
- Cost: **0.5 STX**
- Conditions:
  - Must not exceed `max-supply`
  - Caller must have enough balance
- Returns: `token-id` of newly minted NFT

### `whitelist-mint`
- Cost: **0.25 STX**
- Requires whitelist access
- Automatically removes user from whitelist after minting

---

## 💰 Royalties & Transfers

### `transfer`
- Includes a **5% royalty** fee (configurable) paid to the contract owner.
- Only the current NFT owner can initiate a transfer.

---

## 🛠 Admin Functions

Only the contract owner can call the following:

| Function | Description |
|---------|-------------|
| `set-mint-price` | Update public mint price |
| `set-whitelist-mint-price` | Update whitelist mint price |
| `set-royalty-percent` | Change royalty percentage (0–100) |
| `set-base-uri` | Update base URI for metadata |
| `reveal-collection` | Set the collection as "revealed" |
| `add-to-whitelist`, `remove-from-whitelist` | Manage whitelist |
| `withdraw-funds` | Withdraw all contract funds |

---

## 📖 Read-Only Functions

| Function | Returns |
|----------|---------|
| `get-last-token-id` | Last minted token ID |
| `get-owner` | Owner of specific token |
| `get-token-attributes` | Metadata attributes of token |
| `get-token-traits` | Trait booleans of token |
| `is-whitelisted` | Whether an address is whitelisted |

---

## 🔐 Errors

| Code | Meaning |
|------|--------|
| `101` | Sold out |
| `102` | Insufficient funds |
| `103` | Caller is not contract owner |
| `104` | Already minted (unused) |
| `105` | Caller not whitelisted |
| `106` | Invalid token ID |
| `107` | Metadata not revealed yet |
| `108` | Invalid royalty percentage |

---

## 🌐 Metadata & Reveal

The base URI (default: `https://le-baguette-nft.com/metadata/`) will be used for token metadata. The `revealed` flag allows for metadata to be hidden until officially revealed.

---

## 🧪 Example Use

```clojure
;; Mint a baguette
(mint-baguette)

;; Check who owns token 5
(get-owner u5)

;; Get traits of a baguette
(get-token-traits u10)

;; Admin: Reveal collection
(reveal-collection)
```

