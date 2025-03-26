# Go project structure

A generic project structure for Go projects, can be used for multiple purposed.
This one aims to be used for 3PL tracking system to have a clear detail of the project structure.

## Features

- Components:
    - Web APIs
    - Background jobs
    - Message brokers
    - Databases
    - External APIs
    - Webhooks
    - CI/CD pipelines
    - Local development environment
- Business features:
    - Shipment events tracking provider
    - Polling/Webhook support
    - Cronjobs/Workers for async/background tasks
    - Kafka messaging
    - Carrier-specific adapters
    - Tracking provider integrations
- OPS for devops tasks:
    - Infrastructure as code
    - CI/CD configurations
    - Local development environment setup

## Project Structure

```
├── .github/             # GitHub Actions workflows
│   └── workflows/       
│       └── *.yml        
├── Makefile             # Commands for migrations and tests
├── README.md            # Project documentation
|-- ops/                 # Deployment scripts and utilities
│   ├── dev/               # Local development environment setup
│   ├── ci-cd/             # CI/CD configurations
│   ├── infrastructure/    # Infrastructure as code
├── cmd/                 # Executable files for the application
│   ├── main.go            # Main application entry point
│   ├── cronjobs/          # Directory for cronjob executables
│   │   ├── tracking-updater/   # Cronjob for updating tracking info
│   │   │   └── main.go         # Entry point for this cronjob
│   │   └── ...                 # Other cronjobs
├── internal/            # Private packages used within the application
│   ├── adapters/       # Adapters for external services
│   │   ├── carriers/     # Carrier-specific integrations
│   │   |   ├── carrier.go        # Main interface of carrier
│   │   |   ├── mocks/            # Mocks
│   │   |   |   ├── carrier_mock.go   # Shipment model mock
│   │   |   ├── fedex/      # FedEx-specific implementation
│   │   |   |   ├── fedex.go       # FedEx adapter
│   │   |   |   ├── fedex_test.go  # FedEx adapter unit tests
│   │   └── tracking/      # Tracking provider integrations
│   ├── domain/            # Business domain logic
│   │   ├── models/          # Data models (e.g., Shipment, Parcel)
│   │   ├── repositories/    # Data access layer
│   │   └── services/        # Business logic implementations
│   ├── infrastructure/    # Infrastructure-related code
│   │   ├── messaging/
│   │   │   ├── kafka/          # Kafka-specific implementation
│   │   │   │   ├── consumers/
│   │   │   │   ├── producers/
│   │   │   │   ├── config/
│   │   │   │   └── messages/
│   │   ├── databases/  # Database connections and migrations
│   │   └── webhooks/   # Webhook handling logic
│   └── utils/        # Utility functions (e.g., logging, errors)
└── pkg/            # Reusable packages that can be used across projects
|   ├── client/          # HTTP clients for external APIs
|   ├── config/          # Configuration management
|   └── logger/          # Logging utilities
├── test/                       # Test directories
│   ├── integration/            # Integration tests
└── vendor/                     # Dependencies
```

## Interface & Implementation

Courage centralizing interfaces in a single package to avoid cyclic dependencies. Easy to expand and maintain. Here is an example of how to define an interface and its implementation:

Interface Definition `internal/adapters/carriers/carrier.go`:
```go
package carriers

type Carrier interface {
    CreateShipment(parcel *domain.Parcel) (*domain.Shipment, error)
    TrackShipment(shipmentID string) (*domain.TrackingInfo, error)
    CancelShipment(shipmentID string) error
}
```

Implementation `internal/adapters/carriers/fedex/fedex.go`:
```go
package fedex

// Implementation specific to FedEx

import (
    "your-project/internal/domain"
)

type FedEx struct {
    // Dependencies (e.g., HTTP client, API credentials)
}

func NewFedEx(config *Config) *FedEx {
    return &FedEx{
        // Initialize dependencies
    }
}

func (f *FedEx) CreateShipment(parcel *domain.Parcel) (*domain.Shipment, error) {
    // TBD
}

func (f *FedEx) TrackShipment(shipmentID string) (*domain.TrackingInfo, error) {
    // TBD
}

func (f *FedEx) CancelShipment(shipmentID string) error {
    // TBD
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
