# Define the binary name and main Go file
BINARY_NAME=jdbc_exporter
MAIN_ENTRY=launcher/main/main.go

# Find all Go files to watch for changes
GO_FILES=$(wildcard **/*.go)

# Go commands
BUILD_CMD=go build
RUN_CMD=go run
TEST_CMD=go test
FMT_CMD=go fmt
CLEAN_CMD=go clean
VET_CMD=go vet

# Build output directories
BUILD_DIR?=build

# Set version
VERSION := 1.0.0

.PHONY: all build run test fmt vet clean help linux linux-arm64 windows

# Default target
all: fmt vet build

# Build the binary
build:
	@echo "Building the binary ($(BINARY_NAME)) for the current platform..."
	$(BUILD_CMD) -o $(BINARY_NAME) $(MAIN_ENTRY)

# Cross compile for linux
build-linux:
	@echo "Building for Linux..."
	GOOS=linux GOARCH=amd64 $(BUILD_CMD) -o $(BUILD_DIR)/$(BINARY_NAME)_linux_amd64 $(MAIN_ENTRY)

# Cross compile for linux-arm64
build-linux-arm64:
	@echo "Building for Linux ARM64..."
	GOOS=linux GOARCH=arm64 $(BUILD_CMD) -o $(BUILD_DIR)/$(BINARY_NAME)_linux_arm64 $(MAIN_ENTRY)

# Cross compile for windows
build-windows:
	@echo "Building for Windows..."
	GOOS=windows GOARCH=amd64 $(BUILD_CMD) -o $(BUILD_DIR)/$(BINARY_NAME)_windows_amd64.exe $(MAIN_ENTRY)

# Run the project (does not produce a binary)
run:
	@echo "Running the project..."
	$(RUN_CMD) $(MAIN_ENTRY)

# Run all tests in the project
test:
	@echo "Running tests..."
	$(TEST_CMD) ./...

# Format the code
fmt:
	@echo "Formatting code..."
	$(FMT_CMD) ./...

# Run Go Vet to check for potential issues in code
vet:
	@echo "Running go vet..."
	$(VET_CMD) ./...

# Clean generated files
clean:
	@echo "Cleaning build artifacts..."
	$(CLEAN_CMD)
	rm -f $(BINARY_NAME)
	rm -rf $(BUILD_DIR)

# Watch for file changes and rebuild automatically (requires entr)
watch:
	@echo "Watching for file changes..."
	@ls $(GO_FILES) | entr -d make all

# Help target to show available commands
help:
	@echo "Available targets:"
	@echo "  all                - Format, vet, and build the project"
	@echo "  build              - Build a binary from the Go project"
	@echo "  run                - Run the project without creating a binary"
	@echo "  test               - Run all tests in the project"
	@echo "  fmt                - Format all Go code with 'go fmt'"
	@echo "  vet                - Run 'go vet' to check for potential problems"
	@echo "  clean              - Remove generated binaries and temporary files"
	@echo "  watch              - Watch for file changes and rebuild automatically (entr required)"
	@echo "  build-linux        - Build the binary for Linux AMD64"
	@echo "  build-linux-arm64  - Build the binary for Linux ARM64"
	@echo "  build-windows      - Build the binary for Windows AMD64"
