-- INSERTS: typesofidentifications

INSERT INTO typesofidentifications (id, description, sufix) VALUES
(1, 'CÉDULA DE CIUDADANÍA', 'CC'),
(2, 'CÉDULA DE EXTRANJERÍA', 'CE'),
(3, 'NÚMERO DE IDENTIFICACIÓN TRIBUTARIA', 'NIT'),
(4, 'PASAPORTE', 'PA'),
(5, 'PERMISO ESPECIAL', 'PEP'),
(6, 'TARJETA DE IDENTIDAD', 'TI'),
(7, 'REGISTRO CIVIL', 'RC'),
(8, 'DOCUMENTO EXTRANJERO', 'DE'),
(9, 'SIN DOCUMENTO', 'SD');


-- INSERTS: audiences

INSERT INTO audiences (id, description) VALUES
(1, 'PÚBLICO GENERAL'),
(2, 'MAYORISTA'),
(3, 'VIP'),
(4, 'ESTUDIANTE'),
(5, 'PREMIUM'),
(6, 'FANÁTICO'),
(7, 'TALLER MECÁNICO'),
(8, 'CORREDOR'),
(9, 'REVENDEDOR'),
(10, 'FAMILIA');

-- INSERTS: customers
INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) 
VALUES (11, 'FERNANDO ALONSO', '11001', 11, '322 456 7890', 'fernando.alonso@gmail.com', 'Carrera 10 #11-21');

INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) 
VALUES (12, 'DANICA PATRICK', '25001', 12, '300 123 4567', 'danica.patrick@gmail.com', 'Calle 12 #10-30');

INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) 
VALUES (13, 'VALENTINO ROSSI', '41001', 13, '301 654 9870', 'valentino.rossi@gmail.com', 'Avenida 1 #45-89');

INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) 
VALUES (14, 'SIMONA DE SILVESTRO', '73001', 14, '313 789 4561', 'simona.silvestro@gmail.com', 'Transversal 23 #89-20');

INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) 
VALUES (15, 'CHARLES LECLERC', '88001', 15, '310 444 1122', 'charles.leclerc@gmail.com', 'Calle 60 #40-22');

INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) 
VALUES (16, 'PIERRE GASLY', '27001', 16, '314 115 3344', 'pierre.gasly@gmail.com', 'Carrera 33 #56-70');

INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) 
VALUES (17, 'GEORGE RUSSELL', '47001', 17, '315 998 7766', 'george.russell@gmail.com', 'Diagonal 9 #12-14');

INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) 
VALUES (18, 'ALEXANDER ALBON', '85001', 18, '316 667 8899', 'alex.albon@gmail.com', 'Calle 100 #20-18');

INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) 
VALUES (19, 'LANDO NORRIS', '91001', 19, '317 778 6655', 'lando.norris@gmail.com', 'Carrera 15 #80-55');

INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) 
VALUES (20, 'OSCAR PIASTRI', '94001', 20, '318 559 4433', 'oscar.piastri@gmail.com', 'Calle 85 #90-12');


-- INSERTS: categories
INSERT INTO categories (id, description) VALUES (6, 'JUGUETERÍA');
INSERT INTO categories (id, description) VALUES (7, 'DEPORTES');
INSERT INTO categories (id, description) VALUES (8, 'LIBRERÍA');
INSERT INTO categories (id, description) VALUES (9, 'COSMÉTICOS');
INSERT INTO categories (id, description) VALUES (10, 'ALIMENTOS');

-- INSERTS: categories_polls
INSERT INTO categories_polls (id, name) VALUES (1, 'Calidad del producto');
INSERT INTO categories_polls (id, name) VALUES (2, 'Servicio al cliente');
INSERT INTO categories_polls (id, name) VALUES (3, 'Rapidez');
INSERT INTO categories_polls (id, name) VALUES (4, 'Precio');
INSERT INTO categories_polls (id, name) VALUES (5, 'Disponibilidad');
-- INSERTS: companies
INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES ('90012011-7', 2, 'FERNANDO ALONSO S.A.S', 1, '25001', 1, '321 456 7890', 'fernando.alonso@gmail.com');
INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES ('90012012-7', 2, 'KIMI RÄIKKÖNEN S.A.S', 2, '88001', 2, '300 112 3344', 'kimi.raikkonen@gmail.com');
INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES ('90012013-7', 2, 'DANIEL RICCIARDO S.A.S', 3, '81001', 3, '315 221 8877', 'daniel.ricciardo@gmail.com');
INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES ('90012014-7', 2, 'VALTTERI BOTTAS S.A.S', 4, '41001', 4, '313 559 2033', 'valtteri.bottas@gmail.com');
INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES ('90012015-7', 2, 'CARLOS SAINZ S.A.S', 5, '47001', 5, '316 800 9090', 'carlos.sainz@gmail.com');
INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES ('90012016-7', 2, 'GEORGE RUSSELL S.A.S', 6, '23001', 6, '322 133 2424', 'george.russell@gmail.com');
INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES ('90012017-7', 2, 'CHARLES LECLERC S.A.S', 7, '27001', 7, '350 774 1188', 'charles.leclerc@gmail.com');
INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES ('90012018-7', 2, 'PIERRE GASLY S.A.S', 8, '63001', 8, '370 855 6677', 'pierre.gasly@gmail.com');
INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES ('90012019-7', 2, 'ESTEBAN OCON S.A.S', 9, '73024', 9, '345 993 2233', 'esteban.ocon@gmail.com');
INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES ('90012020-7', 2, 'YUKI TSUNODA S.A.S', 10, '76054', 10, '301 800 5522', 'yuki.tsunoda@gmail.com');

-- INSERTS: unitofmeasure
INSERT INTO unitofmeasure (id, description) VALUES (1, 'UNIDAD');
INSERT INTO unitofmeasure (id, description) VALUES (2, 'CAJA');
INSERT INTO unitofmeasure (id, description) VALUES (3, 'LITRO');
INSERT INTO unitofmeasure (id, description) VALUES (4, 'KILOGRAMO');
INSERT INTO unitofmeasure (id, description) VALUES (5, 'PAR');
-- INSERTS: products
INSERT INTO products (id, name, detail, price, category_id) 
VALUES (1, 'Cámara de seguridad WiFi', 'Cámara HD con visión nocturna y detección de movimiento', 95000.00, 1);

INSERT INTO products (id, name, detail, price, category_id) 
VALUES (2, 'Camiseta edición piloto', 'Camiseta deportiva oficial con logos bordados', 35000.00, 2);

INSERT INTO products (id, name, detail, price, category_id) 
VALUES (3, 'Cafetera de cápsulas', 'Cafetera automática para cápsulas reutilizables', 160000.00, 3);

INSERT INTO products (id, name, detail, price, category_id) 
VALUES (4, 'Tablet 10 pulgadas', 'Pantalla IPS, 64GB de almacenamiento y Android 12', 480000.00, 4);

INSERT INTO products (id, name, detail, price, category_id) 
VALUES (5, 'Kit de pulido automotriz', 'Incluye máquina pulidora, esponjas y líquidos', 190000.00, 5);

INSERT INTO products (id, name, detail, price, category_id) 
VALUES (6, 'Set de bloques magnéticos', '70 piezas de construcción para niños mayores de 3 años', 42000.00, 6);

INSERT INTO products (id, name, detail, price, category_id) 
VALUES (7, 'Balón profesional fútbol', 'Balón FIFA calidad match oficial', 79000.00, 7);

INSERT INTO products (id, name, detail, price, category_id) 
VALUES (8, 'Colección de libros clásicos', 'Incluye 10 títulos con encuadernación de lujo', 125000.00, 8);

INSERT INTO products (id, name, detail, price, category_id) 
VALUES (9, 'Set de brochas de maquillaje', '12 piezas profesionales con estuche', 68000.00, 9);

INSERT INTO products (id, name, detail, price, category_id) 
VALUES (10, 'Canasta surtida de snacks', 'Variedad de golosinas y productos importados', 52000.00, 10);



-- INSERTS: companyproducts
INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES ('90012001-7', 11, 97000.00, 1);
INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES ('90012002-7', 12, 36000.00, 1);
INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES ('90012003-7', 13, 165000.00, 1);
INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES ('90012004-7', 14, 490000.00, 1);
INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES ('90012005-7', 15, 192000.00, 1);
INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES ('90012006-7', 16, 43000.00, 1);
INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES ('90012007-7', 17, 82000.00, 1);
INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES ('90012008-7', 18, 128000.00, 1);
INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES ('90012009-7', 19, 69000.00, 1);
INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES ('90012010-7', 20, 54000.00, 1);


-- INSERTS: favorites
INSERT INTO favorites (id, customer_id, company_id) VALUES (1, 1, '90012003-7');
INSERT INTO favorites (id, customer_id, company_id) VALUES (2, 2, '90012005-7');
INSERT INTO favorites (id, customer_id, company_id) VALUES (3, 3, '90012001-7');
INSERT INTO favorites (id, customer_id, company_id) VALUES (4, 4, '90012007-7');
INSERT INTO favorites (id, customer_id, company_id) VALUES (5, 5, '90012009-7');
INSERT INTO favorites (id, customer_id, company_id) VALUES (6, 6, '90012004-7');
INSERT INTO favorites (id, customer_id, company_id) VALUES (7, 7, '90012010-7');
INSERT INTO favorites (id, customer_id, company_id) VALUES (8, 8, '90012002-7');
INSERT INTO favorites (id, customer_id, company_id) VALUES (9, 9, '90012008-7');
INSERT INTO favorites (id, customer_id, company_id) VALUES (10, 10, '90012006-7');

-- INSERTS: details_favorites
INSERT INTO details_favorites (favorite_id, product_id, category_id) VALUES (1, 4, 5);
INSERT INTO details_favorites (favorite_id, product_id, category_id) VALUES (2, 1, 2);
INSERT INTO details_favorites (favorite_id, product_id, category_id) VALUES (3, 6, 4);
INSERT INTO details_favorites (favorite_id, product_id, category_id) VALUES (4, 10, 5);
INSERT INTO details_favorites (favorite_id, product_id, category_id) VALUES (5, 7, 3);
INSERT INTO details_favorites (favorite_id, product_id, category_id) VALUES (6, 2, 5);
INSERT INTO details_favorites (favorite_id, product_id, category_id) VALUES (7, 8, 1);
INSERT INTO details_favorites (favorite_id, product_id, category_id) VALUES (8, 5, 2);
INSERT INTO details_favorites (favorite_id, product_id, category_id) VALUES (9, 3, 2);
INSERT INTO details_favorites (favorite_id, product_id, category_id) VALUES (10, 9, 4);

-- INSERTS: polls
INSERT INTO polls (id, name, description, isactive, categorypoll_id) VALUES (1, 'Satisfacción general tienda #1', 'Evalúa la experiencia de compra en la tienda', TRUE, 1);
INSERT INTO polls (id, name, description, isactive, categorypoll_id) VALUES (2, 'Atención al cliente tienda #2', 'Califica la calidad del servicio recibido', FALSE, 2);
INSERT INTO polls (id, name, description, isactive, categorypoll_id) VALUES (3, 'Velocidad de entrega tienda #3', 'Opinión sobre tiempos de entrega', TRUE, 3);
INSERT INTO polls (id, name, description, isactive, categorypoll_id) VALUES (4, 'Valor del producto tienda #4', 'Relación calidad-precio del producto adquirido', TRUE, 4);
INSERT INTO polls (id, name, description, isactive, categorypoll_id) VALUES (5, 'Stock y variedad tienda #5', 'Opinión sobre disponibilidad de productos', FALSE, 5);

-- INSERTS: rates
INSERT INTO rates (customer_id, company_id, poll_id, daterating, rating) VALUES (1, '90012003-7', 3, '2025-07-16 08:15:32', 5);
INSERT INTO rates (customer_id, company_id, poll_id, daterating, rating) VALUES (2, '90012005-7', 2, '2025-07-16 09:02:14', 4);
INSERT INTO rates (customer_id, company_id, poll_id, daterating, rating) VALUES (3, '90012001-7', 1, '2025-07-16 09:45:08', 2);
INSERT INTO rates (customer_id, company_id, poll_id, daterating, rating) VALUES (4, '90012007-7', 4, '2025-07-16 10:12:55', 4);
INSERT INTO rates (customer_id, company_id, poll_id, daterating, rating) VALUES (5, '90012009-7', 5, '2025-07-16 10:30:41', 5);


-- INSERTS: quality_products
INSERT INTO quality_products (product_id, customer_id, poll_id, company_id, daterating, rating) VALUES (1, 1, 1, '90012001-7', '2025-07-16 02:49:01', 5);
INSERT INTO quality_products (product_id, customer_id, poll_id, company_id, daterating, rating) VALUES (2, 2, 2, '90012002-7', '2025-07-16 02:49:01', 3);
INSERT INTO quality_products (product_id, customer_id, poll_id, company_id, daterating, rating) VALUES (3, 3, 3, '90012003-7', '2025-07-16 02:49:01', 3);
INSERT INTO quality_products (product_id, customer_id, poll_id, company_id, daterating, rating) VALUES (4, 4, 4, '90012004-7', '2025-07-16 02:49:01', 4);
INSERT INTO quality_products (product_id, customer_id, poll_id, company_id, daterating, rating) VALUES (5, 5, 5, '90012005-7', '2025-07-16 02:49:01', 3);

-- INSERTS: memberships

INSERT INTO memberships (id, name, description) VALUES (1, 'BÁSICA', 'Acceso limitado a beneficios');
INSERT INTO memberships (id, name, description) VALUES (2, 'ORO', 'Beneficios preferenciales');
INSERT INTO memberships (id, name, description) VALUES (3, 'PLATINO', 'Todos los beneficios disponibles');
INSERT INTO memberships (id, name, description) VALUES (4, 'RACING PRO', 'Acceso exclusivo a productos de carrera');


-- INSERTS: periods

INSERT INTO periods (id, name) VALUES
(1, 'MENSUAL'),
(2, 'TRIMESTRAL'),
(3, 'ANUAL'),
(4, 'SEMESTRAL');


-- INSERTS: membershipperiods

INSERT INTO membershipperiods (membership_id, period_id, price) VALUES
(1, 1, 10000),
(2, 1, 25000),
(3, 1, 40000),
(4, 1, 50000),
(4, 3, 150000);


-- INSERTS: benefits

INSERT INTO benefits (id, description, detail) VALUES
(1, 'ENVÍO GRATIS', 'No pagas envío en ninguna compra'),
(2, 'ATENCIÓN VIP', 'Acceso a línea de atención preferencial'),
(3, 'SOPORTE 24/7', 'Asistencia en cualquier momento del día'),
(4, 'DESCUENTO EXCLUSIVO', '10% en productos seleccionados'),
(5, 'ACCESO ANTICIPADO', 'Compra antes que el público general');


-- INSERTS: membershipbenefits

INSERT INTO membershipbenefits (membership_id, period_id, audience_id, benefit_id) VALUES
(4, 1, 8, 1),
(4, 1, 8, 2),
(4, 1, 8, 3),
(3, 1, 3, 1),
(2, 1, 1, 4);

-- INSERTS: audiencebenefits

INSERT INTO audiencebenefits (audience_id, benefit_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
