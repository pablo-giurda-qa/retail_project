CREATE DATABASE retail_project;

DROP TABLE IF EXISTS clientes;
CREATE TABLE clientes (
cliente_id SERIAL PRIMARY KEY,
nombre VARCHAR(200) NOT NULL,
edad INT NOT NULL,
email VARCHAR(150) UNIQUE NOT NULL,
CONSTRAINT chk_edad_valida CHECK (edad >= 18)
);

DROP TABLE IF EXISTS productos;
CREATE TABLE productos (
producto_id SERIAL PRIMARY KEY,
nombre VARCHAR(200) NOT NULL,
precio DECIMAL(7,2) NOT NULL,
stock INT NOT NULL,
CONSTRAINT chk_precio_valido CHECK (precio > 0),
CONSTRAINT chk_stock_valido CHECK (stock >= 0)
);

DROP TABLE IF EXISTS ventas;
CREATE TABLE ventas (
venta_id SERIAL PRIMARY KEY,
cliente_id INT NOT NULL,
producto_id INT NOT NULL,
cantidad INT NOT NULL,
fecha_venta DATE NOT NULL,
CONSTRAINT chk_cantidad_valida CHECK (cantidad > 0),
CONSTRAINT fk_ventas_clientes FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
ON DELETE CASCADE,
CONSTRAINT fk_ventas_productos FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

BEGIN;
INSERT INTO clientes (nombre, edad, email) VALUES
('Mario Toledo', 27, 'mario@gmail.com'),
('Carlos Peralta', 30, 'carlos@gmail.com'),
('Pablo Gigena', 18, 'pablo@gmail.com'),
('Carolina Herrera', 38, 'carolina@gmail.com'),
('Graciela Pereyra', 58, 'graciela@gmail.com');

INSERT INTO productos (nombre, precio, stock) VALUES
('Papel higienico', 1350.50, 15000),
('Rollo de cocina', 1520.70, 20000),
('Escobilla de baño', 2200, 6000),
('Esponja', 505.80, 50000),
('Detergente', 1100.50, 9000);

INSERT INTO ventas (cliente_id, producto_id, cantidad, fecha_venta) VALUES
(1, 2, 5, '2026-05-20'),
(3, 5, 10, '2026-05-15'),
(2, 3, 7, '2026-06-02'),
(4, 4, 6, '2026-07-18'),
(1, 4, 15, '2026-08-01');
COMMIT;

ALTER TABLE productos
ADD COLUMN categoria VARCHAR(150) NOT NULL DEFAULT 'General';

BEGIN;
UPDATE productos SET categoria = 'Cocina'
WHERE producto_id IN (2, 4, 5);

UPDATE productos SET categoria = 'Baño'
WHERE producto_id IN (1, 3);

UPDATE productos SET precio = precio + (precio * 0.15)
WHERE categoria = 'Baño';

DELETE FROM ventas 
WHERE fecha_venta < '2026-06-01';

COMMIT;
