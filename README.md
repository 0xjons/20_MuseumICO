# 20_MuseumICO# Museum ICO & NFT Contracts

Este proyecto consiste en dos contratos inteligentes para la creación y manejo de una ICO para un token ERC20, `MuseumICOERC20`, y la acuñación de NFTs utilizando el token ERC20 como moneda de cambio, `MuseumICONFT`.

## Contratos

- `MuseumICOERC20`: Contrato de token ERC20 para la ICO. Implementa una lógica especial que otorga el doble de tokens para los primeros 30,000 tokens vendidos.
- `MuseumICONFT`: Contrato de token ERC721 para la acuñación de NFTs. Permite a los usuarios mintear NFTs pagando con ETH, que se convierte automáticamente en tokens ERC20 del contrato `MuseumICOERC20`.

## Despliegue

### Paso 1: Desplegar `MuseumICOERC20`

1. Desplegar el contrato `MuseumICOERC20` en la red de prueba deseada.
2. Anotar la dirección del contrato desplegado.

### Paso 2: Desplegar `MuseumICONFT`

1. Desplegar el contrato `MuseumICONFT`, pasando la dirección del contrato `MuseumICOERC20` desplegado en el paso anterior como argumento del constructor.
2. Anotar la dirección del contrato `MuseumICONFT` desplegado.

### Paso 3: Establecer el Caller Autorizado

1. Llamar a la función `setAuthorizedCaller` en el contrato `MuseumICOERC20`, pasando la dirección del contrato `MuseumICONFT` como argumento. Esto autoriza al contrato `MuseumICONFT` a llamar a la función `buyTokens` en `MuseumICOERC20`.

## Comprar un NFT

Para comprar un NFT en la red de prueba, sigue estos pasos:

1. Asegúrate de tener suficiente ETH en tu billetera para cubrir el costo del NFT y las tarifas de gas.
2. Interactúa con el contrato `MuseumICONFT` y llama a la función `mintNFT`, especificando la cantidad de NFTs que deseas mintear y enviando suficiente ETH para cubrir el costo.
3. La transacción convertirá automáticamente el ETH enviado en tokens ERC20 y utilizará estos tokens para mintear el NFT.
4. Una vez completada la transacción, deberías ser el propietario del NFT minteado y tu saldo de tokens ERC20 debería aumentar según la política de bonificación del contrato `MuseumICOERC20`.

## Verificar Saldo y Propiedad

- Para verificar tu saldo de tokens ERC20, interactúa con el contrato `MuseumICOERC20` y utiliza la función `balanceOf`, pasando tu dirección como argumento.
- Para verificar la propiedad de un NFT, interactúa con el contrato `MuseumICONFT` y utiliza la función `ownerOf`, pasando el ID del token NFT como argumento.

## Retirar Fondos

El owner del contrato `MuseumICONFT` puede retirar los fondos acumulados (ETH) por la venta de NFTs llamando a la función `withdraw`.

