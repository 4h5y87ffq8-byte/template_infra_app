-- Insert sample data for testing
INSERT INTO messages (title, content, author, created_at, updated_at) VALUES
('Welcome Message', 'Welcome to Template Application! This is a sample message.', 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Getting Started', 'Follow the README to get started with this application.', 'admin', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Docker Setup', 'The application runs in Docker containers for easy deployment.', 'devops', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
