# 🏴‍☠️ — CTF Web3 (Ekoparty 2026)

Reto **entry level** de seguridad Web3. El objetivo es simple: **abrir la bóveda** llamando a la función `abrir()` del contrato con la clave correcta, firmando la transacción desde **tu propia wallet** en la red de pruebas **Sepolia**.

> 💡 **La lección del reto:** en la blockchain *todo es público*, incluso lo que parece escondido. No hace falta "hackear" nada: solo hay que saber mirar.

---

## 📋 Datos del reto

| Dato | Valor |
|------|-------|
| **Contrato** | `0xB41B09ef7139A38982a92835AA7ccF9ebC6F998b` |
| **Red** | Sepolia (testnet de Ethereum) |
| **Función objetivo** | `abrir(string clave)` |
| **Costo** | Gratis (se usa ETH de prueba, **no tiene valor real**) |

🔎 Podés ver el contrato en el explorador:
`https://sepolia.etherscan.io/address/0xB41B09ef7139A38982a92835AA7ccF9ebC6F998b`

---

## 🗺️ Resumen de los pasos

1. [Instalar MetaMask y crear una wallet](#paso-1-instalar-metamask-y-crear-una-wallet)
2. [Activar la red Sepolia](#paso-2-activar-la-red-sepolia)
3. [Pedir ETH de prueba en un faucet](#paso-3-pedir-eth-de-prueba-faucet)
4. [Abrir Remix y conectar el contrato](#paso-4-abrir-remix-y-conectarse-al-contrato)
5. [Explorar las pistas e interactuar](#paso-5-explorar-las-pistas)
6. [Resolver: llamar a `abrir()`](#paso-6-resolver-llamar-a-abrir)
7. [Verificar que quedaste registrado](#paso-7-verificar-tu-solucion)

---

## Paso 1: Instalar MetaMask y crear una wallet

MetaMask es una "billetera" de criptomonedas que vive como extensión de tu navegador. La necesitás para firmar transacciones.

1. Entrá a la web **oficial**: 👉 **https://metamask.io/download**
   - ⚠️ Instalá solo desde ahí. Nunca busques "metamask" en Google y hagas clic en un anuncio: hay extensiones falsas que roban fondos.
2. Agregá la extensión a tu navegador (Chrome, Brave, Firefox o Edge).
3. Elegí **"Crear una wallet nueva"** y seguí los pasos.
4. Vas a recibir una **frase de recuperación (Secret Recovery Phrase)** de 12 palabras.
   - 🔐 **Anotala en papel y guardala.** Quien tenga esa frase controla tu wallet.
   - Para este CTF podés usar una wallet nueva/descartable sin problema.
5. Al terminar vas a ver tu **dirección pública**, algo como `0x1234...abcd`. Esa es tu identidad en la blockchain (es pública, podés compartirla).

> 📌 Hacé clic en el ícono de MetaMask y fijalo (pin) en la barra del navegador para tenerlo a mano.

---

## Paso 2: Activar la red Sepolia

El contrato vive en **Sepolia**, no en la red principal de Ethereum. Hay que decirle a MetaMask que la muestre.

1. Abrí MetaMask y hacé clic en el **selector de red** (arriba a la izquierda, suele decir "Ethereum Mainnet").
2. Activá la opción **"Show test networks" / "Mostrar redes de prueba"**.
   - En versiones nuevas: ícono de engranaje → **Settings → Advanced → "Show test networks"** → activar.
3. Volvé al selector de red y elegí **"Sepolia"**.

✅ Listo. Arriba debería decir **Sepolia** y tu balance figurará como `0 SepoliaETH`.

---

## Paso 3: Pedir ETH de prueba (faucet)

Para firmar una transacción necesitás un poquito de ETH que pague el "gas" (la comisión de red). En Sepolia ese ETH es **gratis y de prueba**. Se consigue en un **faucet**.

### Opción recomendada: Google Cloud Faucet

1. Entrá a 👉 **https://cloud.google.com/application/web3/faucet/ethereum/sepolia**
2. Iniciá sesión con tu cuenta de **Google**.
3. **Copiá tu dirección** desde MetaMask (clic en tu nombre/dirección → se copia al portapapeles) y **pegala** en el faucet.
4. Hacé clic en **"Receive 0.05 Sepolia ETH"** (o el monto que ofrezca).
5. Esperá unos segundos. En MetaMask (con Sepolia seleccionada) vas a ver llegar el balance.

### Faucets alternativos (por si el de Google pide requisitos)

- https://sepolia-faucet.pk910.de/ (faucet "de minado" en el navegador; útil si no tenés saldo en Mainnet)
- https://www.alchemy.com/faucets/ethereum-sepolia
- https://faucet.quicknode.com/ethereum/sepolia

> 💸 **Con muy poquito alcanza.** Una sola transacción cuesta una fracción mínima. No necesitás juntar mucho.

---

## Paso 4: Abrir Remix y conectarse al contrato

**Remix** es un IDE de Solidity que corre en el navegador. Lo vamos a usar para hablar con el contrato.

1. Abrí 👉 **https://remix.ethereum.org**
2. En la barra lateral izquierda, hacé clic en el ícono **"Deploy & run transactions"** (parece un logo de Ethereum / ▶️, es el cuarto ícono aproximadamente).
3. En el desplegable **"ENVIRONMENT"**, elegí **"Injected Provider - MetaMask"**.
   - Se va a abrir MetaMask pidiendo permiso para conectarse → **aceptá**.
   - ✅ Confirmá que abajo de "Injected Provider" diga **"Custom (11155111) network"** (11155111 es el ID de Sepolia) y que aparezca tu dirección en **ACCOUNT** con tu balance.

### Cargar la interfaz (ABI) del contrato

Para que Remix sepa qué funciones tiene el contrato, le damos su código:

1. En el explorador de archivos (ícono de hojas, arriba a la izquierda), creá un archivo nuevo llamado **`EkoChallenge.sol`**.
2. Pegá adentro **el código del contrato** (el archivo `EkoChallenge.sol` de este repo).
3. Andá al ícono **"Solidity Compiler"** (el que parece una "S") y hacé clic en **"Compile EkoChallenge.sol"**.
   - Asegurate de que la versión del compilador sea **0.8.20 o superior** (el contrato usa `pragma solidity ^0.8.20;`).
   - ✅ Debería aparecer un tilde verde.

### Conectarse al contrato YA desplegado (¡esto es clave!)

El contrato **ya está desplegado**. **NO** hay que hacer "Deploy" (eso crearía uno nuevo y vacío). Lo que hacemos es **apuntar a la dirección existente**:

1. Volvé a **"Deploy & run transactions"**.
2. Confirmá que en **"CONTRACT"** esté seleccionado **`EkoChallenge`**.
3. Buscá el campo **"At Address"** (abajo del botón naranja "Deploy").
4. Pegá la dirección del contrato:
   ```
   0xB41B09ef7139A38982a92835AA7ccF9ebC6F998b
   ```
5. Hacé clic en el botón **"At Address"** (azul).

✅ Abajo, en **"Deployed Contracts"**, va a aparecer **`EKOCHALLENGE AT 0xB41...998B`**. Desplegalo (clic en la flecha ▶) y vas a ver sus funciones como botones.

### Las funciones que vas a usar

Para resolver el reto solo te interesan estas (ignorá el resto):

| Función | Color | Para qué sirve |
|---------|-------|----------------|
| **`bienvenida`** | azul | Mensaje inicial del reto. |
| **`pista`** | azul | Te da la pista con los `datos` a convertir. |
| **`abrir`** | naranja | La función que resuelve el reto (acá va la clave). |
| **`verificar`** | azul | Confirma que resolviste y en qué puesto. |

> Las demás funciones (`cerrar`, `reabrir`, `cantidadDeSolvers`, `verSolvers`, variables públicas, etc.) son de administración o consulta general y **no hace falta tocarlas** para resolver el reto.

---

## Paso 5: Explorar las pistas

Antes de resolver, seguí el recorrido que propone el reto. Los botones **azules** son de solo lectura (gratis, no gastan gas); los **naranjas/rojos** envían una transacción.

1. Hacé clic en **`bienvenida`** (azul) → te da el mensaje inicial.
2. Hacé clic en **`pista`** (azul) → devuelve dos cosas:
   - `mensaje`: un texto que te explica qué hacer.
   - `datos`: un valor que **no está en su forma final**.

### 🔑 Resolver la pista

El valor que devuelve `pista` **no es la clave tal cual**: está representado de otra forma y hay que **convertirlo** para obtener el texto que espera `abrir()`.

Tu trabajo acá es:

1. Leer con atención el `mensaje` de `pista()` → te dice **en qué formato** está la clave.
2. Tomar `datos` y **aplicarle la conversión** correspondiente para pasarlo a texto legible.

> 💡 Hay muchas herramientas gratuitas online para hacer este tipo de conversiones, o podés hacerlo a mano. Ese "convertir" es, justamente, el corazón del reto: *nada está oculto, solo hay que saber interpretar lo que la blockchain ya te muestra.*

El resultado de esa conversión es la **clave** que vas a usar en el próximo paso.

---

## Paso 6: Resolver — llamar a `abrir()`

Este es el momento de firmar la transacción. 🎉

1. En la lista de funciones del contrato, buscá **`abrir`** (es **naranja**, porque modifica el estado).
2. En el campo de texto que aparece al lado (`clave`), escribí **la clave que obtuviste al convertir los `datos` de `pista()`** (Paso 5).
   - ✍️ **Sin comillas** y **sin espacios** alrededor. Solo el texto de la clave.
3. Hacé clic en el botón **`abrir`**.
4. Se abre **MetaMask** mostrando la transacción → hacé clic en **"Confirmar"**.
5. Esperá unos segundos a que se mine. En la consola de Remix (abajo) vas a ver el resultado con un tilde verde ✅ y el evento **`BovedaAbierta`**.

### ⚠️ Condiciones que tenés que cumplir

El contrato exige (si falla, el `require` te dice por qué):

- `La bóveda está cerrada` → la bóveda fue cerrada por el organizador. Avisá para que la reabra.
- `Solo wallets (EOA), no contratos` → tenés que llamar desde una wallet normal (MetaMask), no desde otro contrato.
- `Ya abriste la boveda con esta wallet` → **cada wallet solo puede resolver una vez**. Si querés probar de nuevo, usá otra wallet.
- `Clave incorrecta. Revisa pista()` → revisá tu conversión del Paso 5 y que la hayas escrito sin comillas ni espacios.

---

## Paso 7: Verificar tu solución

Para confirmar que quedaste registrado como solver:

1. Copiá tu dirección de MetaMask.
2. En Remix, en la función **`verificar`** (azul), pegá tu dirección y hacé clic.
   - Devuelve `resuelto = true` y tu **`puesto`** (el número de orden en que resolviste 🏅).
3. Opcional:
   - **`cantidadDeSolvers`** → cuánta gente resolvió el reto.
   - **`verSolvers`** → lista de direcciones (paginada: `desde`, `cantidad`).

🎊 **¡Felicitaciones, abriste la bóveda de la Eko!**

---

## 🧯 Problemas frecuentes

| Problema | Solución |
|----------|----------|
| No veo Sepolia en MetaMask | Settings → Advanced → activar **"Show test networks"**. |
| Balance en 0, no puedo transaccionar | Pedí ETH en el faucet (Paso 3) y esperá a que llegue. |
| En Remix no aparecen mis fondos | En "ENVIRONMENT" elegí **Injected Provider - MetaMask** y verificá que diga red **11155111**. |
| Hice clic en "Deploy" y creé otro contrato | Ignoralo. Usá **"At Address"** con la dirección correcta (Paso 4). |
| La transacción falla con "Clave incorrecta" | Revisá la conversión del Paso 5 y escribí la clave sin comillas ni espacios. |
| "Ya abriste la boveda con esta wallet" | Esa wallet ya resolvió. Usá una wallet nueva si querés repetir. |
| La transacción queda "pendiente" mucho tiempo | Esperá, o en MetaMask usá **"Speed up"**. Sepolia a veces va lenta. |

---

## 🔐 Nota de seguridad

- Este reto usa **ETH de prueba (Sepolia)** que **no tiene ningún valor real**.
- **Nunca** compartas tu frase de recuperación de 12 palabras con nadie, ni la pegues en ningún sitio web.
- Para CTFs conviene usar una **wallet descartable**, separada de la que uses con fondos reales.

---

*· Ekoparty 2026 · Nivel: entry.*
*Built with ❤️ by maximilian0.eth*
