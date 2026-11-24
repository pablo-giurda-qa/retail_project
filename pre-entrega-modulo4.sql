-- Utilizo la base de datos Tienda para realizar los ejecicios

-- Filtra unidades vendidas por categoria y su subtotal
SELECT c.nombre_categoria, COUNT(p.producto_id) AS productos_por_categoria, SUM(dp.cantidad) AS unidades_vendidas, SUM(subtotal) AS total_por_categoria FROM categorias AS c
INNER JOIN productos AS p
ON c.categoria_id = p.categoria_id
INNER JOIN detalle_pedidos AS dp
ON p.producto_id = dp.producto_id
GROUP BY nombre_categoria
HAVING SUM(subtotal) > 30000
ORDER BY total_por_categoria DESC;

/*   PROBLEMA DE NEGOCIO:
  Identificar las categorías de productos más rentables y con mayor volumen de rotación
  para optimizar el inventario y enfocar el presupuesto publicitario.
  
  DECISIÓN DE NEGOCIO:
  Permite focalizar esfuerzos comerciales únicamente en aquellas líneas de productos
  cuyo volumen de ingresos supera el umbral establecido, detectando los motores de venta
  principales de la empresa.*/


-- Filtrar clientes sin compras

SELECT CONCAT(c.nombre , ' ' , c.apellido) AS nombre_completo, COALESCE(CAST(p.pedido_id AS VARCHAR), 'Sin pedidos') AS pedido_realizado FROM clientes AS c
LEFT JOIN pedidos AS p
ON c.cliente_id = p.cliente_id
WHERE p.pedido_id IS NULL;

/* PROBLEMA DE NEGOCIO:
  Detectar usuarios registrados en la plataforma que nunca completaron una transacción.
  
  DECISIÓN DE NEGOCIO:
  Generar la base de contactos para el equipo de Marketing con el fin de activar campañas
  de remarketing, envío de cupones de primer pedido o encuestas de onboarding para
  reducir el abandono inicial.*/

-- Filtrar por productos mas comprado por cliente
SELECT
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_cliente,
    (
        SELECT pr.nombre_producto
        FROM pedidos AS pe2
        INNER JOIN detalle_pedidos AS dp2
            ON pe2.pedido_id = dp2.pedido_id
        INNER JOIN productos AS pr
            ON dp2.producto_id = pr.producto_id
        WHERE pe2.cliente_id = c.cliente_id
        GROUP BY pr.producto_id, pr.nombre_producto
        ORDER BY COUNT(*) DESC, MAX(pe2.fecha_pedido) DESC
        LIMIT 1
    ) AS producto_mas_comprado,
    MAX(pe.fecha_pedido) AS ultima_transaccion
FROM clientes AS c
INNER JOIN pedidos AS pe
    ON c.cliente_id = pe.cliente_id
INNER JOIN detalle_pedidos AS dp
    ON pe.pedido_id = dp.pedido_id
INNER JOIN productos AS p
    ON dp.producto_id = p.producto_id
GROUP BY c.cliente_id, c.nombre, c.apellido;

/*
  PROBLEMA DE NEGOCIO:
  Construir un perfil de consumo por cliente conociendo su preferencia principal de producto
  y el momento de su última actividad.
  
  DECISIÓN DE NEGOCIO:
  Habilita la hiperpersonalización de ofertas: permite recomendar productos afines al artículo
  favorito de cada cliente y detectar clientes en riesgo de inactividad según la fecha de su última compra.
*/