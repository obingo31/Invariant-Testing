# Invariants Testing Playground

# Initialize project
init:
    @echo "Initializing project..."
    @echo "Project initialized successfully"

# Medusa
medusa:
medusa fuzz --config ./mrdusa.json

echidna:
    @echidna-test EchidnaRewarder.sol --contract EchidnaRewarder --config rewarder.yaml

echidna-assert:
    @echidna-test EchidnaRewarder.sol --contract EchidnaRewarder --config rewarder.yaml --test-mode assertion

echidna-explore:
    @echidna-test EchidnaRewarder.sol --contract EchidnaRewarder --config rewarder.yaml --test-mode exploration  

echidna:
        echidna . --contract EchidnaRewarder --config ./rewarder.yaml

               