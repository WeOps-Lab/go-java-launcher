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

.PHONY: all build run test fmt vet clean help

# Default target
all: fmt vet build

# Build the binary
build:
	@echo "Building the binary ($(BINARY_NAME))..."
	$(BUILD_CMD) -o $(BINARY_NAME) $(MAIN_ENTRY)

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

# Watch for file changes and rebuild automatically (requires entr)
watch:
	@echo "Watching for file changes..."
	@ls $(GO_FILES) | entr -d make all

# Help target to show available commands
help:
	@echo "Available targets:"
	@echo "  all     - Format, vet, and build the project"
	@echo "  build   - Build a binary from the Go project"
	@echo "  run     - Run the project without creating a binary"
	@echo "  test    - Run all tests in the project"
	@echo "  fmt     - Format all Go code with 'go fmt'"
	@echo "  vet     - Run 'go vet' to check for potential problems"
	@echo "  clean   - Remove generated binaries and temporary files"
	@echo "  watch   - Watch for file changes and rebuild automatically (entr required)"
