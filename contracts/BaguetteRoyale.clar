;; Baguette Royale- A French-Themed NFT Collection Contract
;; This contract allows minting of artisan baguette NFTs with French-inspired attributes

(define-non-fungible-token baguette-Royale  uint)

;; Storage variables
(define-map token-attributes 
    { token-id: uint }
    { 
        crust: (string-ascii 20),
        filling: (string-ascii 20),
        length: uint,
        flavor: (string-ascii 20),
        rarity: (string-ascii 10)
    }
)
(define-map token-traits
    { token-id: uint }
    { 
        is-organic: bool,
        is-gluten-free: bool,
        has-seeds: bool
    }
)

(define-data-var token-counter uint u0)
(define-data-var mint-price uint u50000000) ;; 0.5 STX
(define-data-var max-supply uint u1000)
(define-data-var base-uri (string-ascii 255) "https://le-baguette-nft.com/metadata/")
(define-data-var revealed bool false)
(define-map whitelist principal bool)
(define-data-var whitelist-mint-price uint u25000000) ;; 0.25 STX for whitelist
(define-data-var royalty-percent uint u5) ;; 5% royalty on secondary sales

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-sold-out (err u101))
(define-constant err-insufficient-funds (err u102))
(define-constant err-not-owner (err u103))
(define-constant err-already-minted (err u104))
(define-constant err-not-whitelisted (err u105))
(define-constant err-invalid-token (err u106))
(define-constant err-not-revealed (err u107))

;; Read-only functions
(define-read-only (get-last-token-id)
    (ok (var-get token-counter))
)

(define-read-only (get-owner (token-id uint))
    (nft-get-owner? le-baguette token-id)
)

(define-read-only (get-token-attributes (token-id uint))
    (map-get? token-attributes { token-id: token-id })
)

(define-read-only (get-token-traits (token-id uint))
    (map-get? token-traits { token-id: token-id })
)

(define-read-only (is-whitelisted (address principal))
    (default-to false (map-get? whitelist address))
)

;; Private functions
(define-private (get-random (seed uint))
    (mod (+ seed block-height) u1000)
)

(define-private (generate-attributes (token-id uint))
    (let (
        (random (get-random token-id))
        (crust-types (list "Crispy" "Soft" "Chewy" "Flaky" "Crunchy"))
        (filling-types (list "Cheese" "Ham" "Butter" "Jam" "Empty"))
        (flavor-types (list "Classic" "Garlic" "Olive" "Herb" "Sourdough"))
        (rarity-types (list "Common" "Uncommon" "Rare" "Epic" "Legendary"))
    )
        {
            crust: (unwrap-panic (element-at crust-types (mod random u5))),
            filling: (unwrap-panic (element-at filling-types (mod (/ random u5) u5))),
            length: (+ u20 (mod random u11)), ;; 20-30 cm
            flavor: (unwrap-panic (element-at flavor-types (mod (/ random u25) u5))),
            rarity: (unwrap-panic (element-at rarity-types (mod (/ random u125) u5)))
        }
    )
)

(define-private (generate-traits (token-id uint))
    (let (
        (random (get-random token-id))
    )
        {
            is-organic: (< (mod random u100) u30), ;; 30% chance
            is-gluten-free: (< (mod (/ random u100) u100) u10), ;; 10% chance
            has-seeds: (< (mod (/ random u10000) u100) u50) ;; 50% chance
        }
    )
)

;; Public functions
(define-public (mint-baguette)
    (let 
        (
            (current-supply (var-get token-counter))
            (new-token-id (+ current-supply u1))
            (caller tx-sender)
        )

        ;; Check max supply
        (asserts! (< current-supply (var-get max-supply)) err-sold-out)

        ;; Check payment
        (asserts! (>= (stx-get-balance caller) (var-get mint-price)) err-insufficient-funds)

        ;; Transfer mint price to contract owner
        (try! (stx-transfer? (var-get mint-price) caller contract-owner))

        ;; Mint NFT
        (try! (nft-mint? le-baguette new-token-id caller))

        ;; Generate and store attributes and traits
        (map-set token-attributes { token-id: new-token-id } (generate-attributes new-token-id))
        (map-set token-traits { token-id: new-token-id } (generate-traits new-token-id))

        ;; Update counter
        (var-set token-counter new-token-id)

        (ok new-token-id)
    )
)
