// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title  La bóveda de la Eko
/// @notice CTF Web3 entry level — Ekoparty 2026
/// @dev    Objetivo: encontrar la clave y llamar a abrir() desde tu wallet en Sepolia.
contract EkoChallenge {
    address public immutable organizador;
    bool public abierto = true;

    bytes32 private constant HASH_CLAVE =
        keccak256(hex"656b6f706172747932303236");

    mapping(address => bool) public resolvio;
    mapping(address => uint256) public puestoDe;
    address[] private solvers;

    event BovedaAbierta(address indexed jugador, uint256 puesto, uint256 timestamp);
    event EstadoCambiado(bool abierto);

    modifier soloOrganizador() {
        require(msg.sender == organizador, "Solo el organizador");
        _;
    }

    constructor() {
        organizador = msg.sender;
    }

    // ------------------------------------------------------------------
    // Paso 1
    // ------------------------------------------------------------------
    function bienvenida() external pure returns (string memory) {
        return unicode"Bienvenid@ a La bóveda de la Eko. En la blockchain todo es público, incluso lo que parece escondido. Llamá a pista() para empezar.";
    }

    // ------------------------------------------------------------------
    // Paso 2
    // ------------------------------------------------------------------
    function pista() external pure returns (string memory mensaje, bytes memory datos) {
        mensaje = unicode"La clave está en hexadecimal. Convertilo y llamá a abrir() con lo que encuentres.";
        datos = hex"656b6f706172747932303236";
    }

    // ------------------------------------------------------------------
    // Paso 3: firmar una transacción desde tu wallet
    // ------------------------------------------------------------------
    function abrir(string calldata clave) external {
        require(abierto, unicode"La bóveda está cerrada");
        require(msg.sender == tx.origin, "Solo wallets (EOA), no contratos");
        require(!resolvio[msg.sender], "Ya abriste la boveda con esta wallet");
        require(keccak256(bytes(clave)) == HASH_CLAVE, "Clave incorrecta. Revisa pista()");

        resolvio[msg.sender] = true;
        solvers.push(msg.sender);
        puestoDe[msg.sender] = solvers.length;

        emit BovedaAbierta(msg.sender, solvers.length, block.timestamp);
    }

    // ------------------------------------------------------------------
    // Verificación (para jugadores y organización)
    // ------------------------------------------------------------------
    function verificar(address jugador) external view returns (bool resuelto, uint256 puesto) {
        return (resolvio[jugador], puestoDe[jugador]);
    }

    function cantidadDeSolvers() external view returns (uint256) {
        return solvers.length;
    }

    /// @notice Lista paginada de solvers (desde, cantidad)
    function verSolvers(uint256 desde, uint256 cantidad) external view returns (address[] memory lista) {
        uint256 total = solvers.length;
        if (desde >= total) return new address[](0);
        uint256 hasta = desde + cantidad > total ? total : desde + cantidad;
        lista = new address[](hasta - desde);
        for (uint256 i = desde; i < hasta; i++) { 
            lista[i - desde] = solvers[i];
        }
    }

    // ------------------------------------------------------------------
    // Administración
    // ------------------------------------------------------------------
    function cerrar() external soloOrganizador {
        abierto = false;
        emit EstadoCambiado(false);
    }

    function reabrir() external soloOrganizador {
        abierto = true;
        emit EstadoCambiado(true);
    }
}
