# README

# Security:
* Some potential attack vectors on the application: when attacker has the short link, they can use it to redirect to phishing domains. Because these links are often used in email, SMS so users easily to click on it.

# Scalability
* Because I have used Redis, and Rails server: 
  Base on the concurrency requests, we need to scale up redis server or Rails server to fit with requests.

* To solve the collision probblem:
  I encode based on the link and sequence so it will not be duplicated the short link.



