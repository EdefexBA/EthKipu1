# Trabajo Final - Módulo 2

## Contrato subasta

### Variables del contrato:

Estructura Bid define la *oferta* (ofertante y monto ofertado).

owner es el dueño del contrato.

highestBidder es el mayor ofertante.

highestBid es el máximo monto ofertado.

auctionEndTime es el momento en que termina la subasta.

auctionEnded es el flag que indica que terminó la subasta.

Bid[] es un array de la estructura de *ofertas*.

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

event NewOffer(address bidder, uint256 amount): se emite cuando hay una oferta (ofertante y monto).

event EndAuction(address winner, uint256 winningBid): se emite cuando el dueño finaliza la subasta mostrando ganador y monto ofertado.

event PartialWithdraw(address bidder, uint256 amount): se emite cuando un ofertante retira parcialmente su(s) oferta(s), excepto la última, sin cobrarle comisión.

### Modificadores:

onlyOwner: funciones aplicables solo para el dueño de la subasta.

auctionActive: funciones aplicables solo cuando la subasta está activa.

hasBids: funciones aplicables solo cuando hay al menos una oferta en la subasta.

### Contructor:

Al deployar el contrato se debe inicializar la oferta base en *highestBid* y tiempo de duración de la subasta en *auctionEndTime*.
    
### Funciones:

makeOffer: ejecuta la oferta si el monto ofertado supera en un 5% al anterior.

showWinner: muestra el ganador y el monto máximo ofertado.

showBids: muesta lista de ofertantes y montos ofertados.

refund: devuelve a todos, excepto al ganador, de todo el dinero ofertado, menos la comisión que va para el ganador.

endAuction: el dueño finaliza la subasta y emite el ganador y monto máximo ofertado.

withdrawCommissions: el dueño retira la comisión y la oferta ganadora.

getAuctionStatus: informa estado de la subasta (si está activa, tiempo restante, total de ofertas y monto recaudado hasta ese momento).

getContractInfo: informa quien es el duenño, cuando termina la subasta, si terminó la subasta, mayor ofertante hasta ese momento y mayor monto ofertado.

partialRefund: un ofertante puede retirar ofertas anteriores a su última oferta, sin aplicarle comisión.

emergencyStop: solo para el dueño para usarlo en casos de emergencia. Detiene la subasta y retira todo lo acumulado.
