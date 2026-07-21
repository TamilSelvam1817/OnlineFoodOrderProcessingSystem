-- SQL Schema for Google OAuth 2.0 Token Storage with AES Encryption
CREATE TABLE IF NOT EXISTS google_accounts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    google_id VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    access_token TEXT,
    refresh_token TEXT,
    expires_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_google_accounts_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS user_oauth (
    user_id BIGINT NOT NULL PRIMARY KEY,
    google_email VARCHAR(255) NOT NULL,
    google_id VARCHAR(255) NOT NULL,
    access_token TEXT,
    refresh_token TEXT,
    expiry_time DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_oauth_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);
