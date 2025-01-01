;; Constants
(define-constant owner tx-sender)
(define-constant err-permission-denied (err u100))
(define-constant err-invalid-owner (err u101))
(define-constant err-token-duplicate (err u102))
(define-constant err-token-missing (err u103))
(define-constant err-invalid-uri (err u104))
(define-constant err-burn-rejected (err u105))
(define-constant err-token-burned (err u106))
(define-constant err-owner-mismatch (err u107))
(define-constant err-invalid-batch-count (err u108))
(define-constant err-batch-failure (err u109))
(define-constant max-batch-amount u100) ;; Maximum allowed minting in a batch

;; Non-fungible Token Declaration
(define-non-fungible-token real-estate-token uint)
(define-data-var current-token-id uint u0)

;; Data Structures
(define-map token-metadata uint (string-ascii 256))
(define-map burned-status uint bool)
(define-map batch-info uint (string-ascii 256))

;; Helper Functions
(define-private (check-token-owner (token-id uint) (sender principal))
    (is-eq sender (unwrap! (nft-get-owner? real-estate-token token-id) false)))

(define-private (is-valid-uri (uri (string-ascii 256)))
    (let ((uri-length (len uri)))
        (and (>= uri-length u1)
             (<= uri-length u256))))

(define-private (is-token-already-burned (token-id uint))
    (default-to false (map-get? burned-status token-id)))

(define-private (mint-new-token (uri (string-ascii 256)))
    (let ((new-token-id (+ (var-get current-token-id) u1)))
        (asserts! (is-valid-uri uri) err-invalid-uri)
        (try! (nft-mint? real-estate-token new-token-id tx-sender))
        (map-set token-metadata new-token-id uri)
        (var-set current-token-id new-token-id)
        (ok new-token-id)))

