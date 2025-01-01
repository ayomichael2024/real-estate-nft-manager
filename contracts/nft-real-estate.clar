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

(define-private (uint-to-token-info (id uint))
    {
        token-id: id,
        uri: (unwrap-panic (get-token-metadata id)),
        owner: (unwrap-panic (get-token-owner id)),
        burned: (unwrap-panic (is-token-burned id))
    })

(define-private (list-tokens (start uint) (count uint))
    (map + 
        (list start) 
        (generate-number-sequence count)))

(define-private (generate-number-sequence (length uint))
    (map - (list length)))

(define-private (transfer-helper (transfer-data {token-id: uint, recipient: principal}) (results (list 100 bool)))
(let ((transfer (transfer-token (get token-id transfer-data) (get recipient transfer-data))))
    (match transfer
        true (append results true)
        false results)))

;; Helper function for batch minting optimization
(define-private (optimized-batch-mint-helper (uri (string-ascii 256)) (previous-results (list 100 uint)))
    (match (mint-new-token uri)
        success (unwrap-panic (as-max-len? (append previous-results success) u100))
        error previous-results))

;; Public Functions
(define-public (mint-token (uri (string-ascii 256)))
    (begin
        ;; Ensure the caller is the contract owner
        (asserts! (is-eq tx-sender owner) err-permission-denied)

        ;; Validate URI
        (asserts! (is-valid-uri uri) err-invalid-uri)

        ;; Mint the token
        (mint-new-token uri)))

(define-public (batch-mint-tokens (uris (list 100 (string-ascii 256))))
    (let ((batch-size (len uris)))
        (begin
            (asserts! (is-eq tx-sender owner) err-permission-denied)
            (asserts! (<= batch-size max-batch-amount) err-invalid-batch-count)
            (asserts! (> batch-size u0) err-invalid-batch-count)

            ;; Mint tokens in batch
            (ok (fold batch-mint-helper uris (list)))
        )))

(define-private (batch-mint-helper (uri (string-ascii 256)) (previous-results (list 100 uint)))
    (match (mint-new-token uri)
        success (unwrap-panic (as-max-len? (append previous-results success) u100))
        error previous-results))

(define-public (burn-token (token-id uint))
    (let ((token-owner (unwrap! (nft-get-owner? real-estate-token token-id) err-token-missing)))
        (asserts! (is-eq tx-sender token-owner) err-invalid-owner)
        (asserts! (not (is-token-already-burned token-id)) err-token-burned)
        (try! (nft-burn? real-estate-token token-id token-owner))
        (map-set burned-status token-id true)
        (ok true)))

