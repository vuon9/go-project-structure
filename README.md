# Go project structure

A generic project structure for Go projects, can be used for multiple purposes.
This one aims to be used for 3PL system to have a clear detail of the project structure.

- What is a 3PL?

A 3PL (third-party logistics) provider offers outsourced logistics services, which encompass anything that involves management of one or more facets of procurement and fulfillment activities. In business, 3PL has a broad meaning that applies to any service contract that involves storing or shipping items.

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
├── ops/                 # Deployment scripts and utilities
├── cmd/                 # Executable files for the application
│   ├── main.go          # Main application entry point for app, worker, cron
├── internal/            # Private packages used within the application
│   ├── adapters/            # Adapters for external services
│   │   ├── carriers/             # Carrier-specific integrations
│   │   |   ├── carrier.go        # Main interfaces of carriers
│   │   |   ├── mocks/            # Mocks
│   │   |   |   ├── carrier_mock.go
│   │   |   ├── fedex/      # FedEx-specific implementation
│   │   |   |   ├── fedex.go       
│   │   |   |   ├── fedex_test.go  
│   │   └── tracking/      # Tracking provider integrations
|   ├── config/           # App configs
│   |   ├── config.go
│   ├── domain/            # Business domain logic
│   │   ├── models/          # Data models (e.g., Shipment, Parcel)
│   │   ├── repositories/    # Data access layer
│   │   └── services/        # Business logic implementations
│   ├── infrastructure/    # Infrastructure-related code
│   │   ├── messaging/       # Messaging tools
│   │   │   ├── kafka/          
│   │   │   │   ├── consumers/
│   │   │   │   ├── producers/
│   │   │   │   ├── config/
│   │   │   │   └── messages/
│   │   ├── databases/      # Database connections and migrations
│   │   └── webhooks/       # Webhook handling logic
│   └── utils/              # Utility functions (e.g., logging, errors)
└── pkg/                 # Reusable packages that can be used across projects
|   ├── httpclient/          # HTTP clients for external APIs
|   ├── kafka/               # Wrapped logics to make using 3rd kafka libraries being more easier.
|   └── logger/              # Logging utilities
├── testutils/           # Test utilities
└── vendor/              # Dependencies
```

## Main

In `cmd/main.go`, it could be a command line structure that support multiple types of program like web, worker, cronjobs. There are some libraries to achieve a simple structure for multiple commands:

- https://github.com/alecthomas/kong
- https://github.com/spf13/cobra

## Config

Here is a great reference of parsing env vars into config struct by libraries and also generate documents for config: https://github.com/g4s8/envdoc?tab=readme-ov-file#compatibility

## Interface & Implementation

Encourage centralizing interfaces in a single package to avoid cyclic dependencies. Easy to expand and maintain. Here is an example of how to define an interface and its implementation:

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

MIT © vuon9
