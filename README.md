# Trabajo Final - Módulo 2

## Contrato subasta

### Variables del contrato:

Estructura Bid define la *oferta* (ofertante y monto ofertado).
owner es el dueño del contrato.
highestBidder es el mayor ofertante.
highestBid es el máximo monto ofertado.
auctionEndTime es el momento en que termina la subasta.
auctionEnded es el flag que indica que terminó la subasta.
Bid[] es un array de *ofertas*.
deposits es un mapeo de cuanto ofertó un ofertante.

    // Variables and struct for bids
    struct Bid {
        address bidder;
        uint256 amount;
    } 
    address public owner;
    address public highestBidder;
    uint256 public highestBid;
    uint256 public auctionEndTime;
    bool public auctionEnded;
    Bid[] public bids;
    mapping(address => uint256) public deposits;

### Eventos:

    event NewOffer(address bidder, uint256 amount);
    Se emite cuando hay una oferta (ofertante y monto).
    
    event EndAuction(address winner, uint256 winningBid);
    Se emite cuando el dueño finaliza la subasta mostrando ganador y monto ofertado.
    
    event PartialWithdraw(address bidder, uint256 amount);
    Se emite cuando un ofertante retira parcialmente su(s) oferta(s), excepto la última, sin cobrarle comisión.

### Modificadores:

    onlyOwner: funciones aplicables solo para el dueño.
    auctionActive: funciones aplicables solo cuando la subasta está activa.
    hasBids: funciones aplicables solo cuando hay al menos una oferta en la subasta.

### Contructor:

    Al deployar el contrato se debe inicializar la oferta base en *highestBid* y tiempo de duración de la subasta en *auctionEndTime*.
    
### Funciones:

    // Make offer
    function makeOffer() external payable auctionActive {
    }
    
    // Show winner
    function showWinner() external hasBids view returns (address winner, uint256 winningBid) {
    }
    
    // Show all bids
    function showBids() external hasBids view returns (Bid[] memory) {
    }
    
    // Refund
    function refund() external hasBids {
    }
    
    // End auction only for owner
    function endAuction() external onlyOwner {
    }
    
    // Withdraw comissions for the owner
    function withdrawCommissions() external onlyOwner hasBids{
    }
    
    // Get auction status
    function getAuctionStatus() external view returns (
        bool isActive, uint256 timeRemaining, uint256 totalBids, uint256 contractBalance
    ) {
    }
    
    // Get contract info
    function getContractInfo() external view returns (
        address contractOwner, uint256 endTime, bool ended, address currentWinner,
        uint256 currentHighestBid) {
    }

    // Partial refund
    function partialRefund() external auctionActive hasBids {

    }

    // Emergency stop
    function emergencyStop() external onlyOwner {
    }
