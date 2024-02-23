-- Crear tabla de roles
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    can_delete BOOLEAN DEFAULT true
);

-- Insertar roles
INSERT INTO roles (nombre, can_delete) VALUES 
  ('Admin', false),
  ('Usuario', true),
  ('Moderador', true);

-- Crear tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    usuario VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol_id INT REFERENCES roles(id) ON DELETE RESTRICT
);

-- Insertar usuario administrador
INSERT INTO usuarios (nombre, usuario, contrasena, rol_id) VALUES 
  ('Administrador', 'admin', 'admin', 1);

-- Crear tabla de sesiones
CREATE TABLE IF NOT EXISTS sesiones (
  sid VARCHAR NOT NULL COLLATE "default",
  sess JSON NOT NULL,
  expire TIMESTAMP(6) NOT NULL,
  CONSTRAINT "sesiones_pkey" PRIMARY KEY (sid)
);

CREATE TABLE alojamientos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio_noche DECIMAL(10, 2) NOT NULL,
    imagen BYTEA
);

-- Función para obtener la información completa del usuario logueado
CREATE OR REPLACE FUNCTION get_user_info(user_id INT)
RETURNS TABLE(nombre VARCHAR, usuario VARCHAR, contrasena VARCHAR, rol_nombre VARCHAR) AS $$
BEGIN
  RETURN QUERY 
  SELECT u.nombre, u.usuario, u.contrasena, r.nombre AS rol_nombre
  FROM usuarios u
  JOIN roles r ON u.rol_id = r.id
  WHERE u.id = user_id
  LIMIT 1;
END;
$$ LANGUAGE plpgsql;
