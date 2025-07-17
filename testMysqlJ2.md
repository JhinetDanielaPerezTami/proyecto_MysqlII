# **Documento Técnico del Proyecto de Base de Datos: Plataforma de Comercialización Digital Multinivel**

## **1. Descripción General del Proyecto**

El presente documento tiene como objetivo describir el diseño e implementación de un sistema de gestión de bases de datos relacional, desarrollado en MySQL, que respalda la operación de una plataforma digital destinada a la comercialización de productos y servicios ofrecidos por empresas registradas. Esta solución se fundamenta en un modelo entidad-relación previamente estructurado, que contempla la gestión integral de clientes, empresas, productos, evaluaciones, membresías, beneficios y ubicaciones geográficas, todo ello con un enfoque escalable y modular.

## **2. Justificación Técnica**

La creciente demanda de plataformas B2C y B2B con soporte para personalización, evaluación de calidad, segmentación de usuarios y fidelización mediante beneficios, exige la implementación de soluciones robustas basadas en esquemas normalizados y eficientes. El modelo propuesto responde a dicha necesidad mediante un diseño altamente relacional, cumpliendo con las buenas prácticas en modelado de datos, seguridad, integridad referencial y expansión futura.

## **3. Objetivo del Sistema de Base de Datos**

Desarrollar e implementar una base de datos normalizada en MySQL que permita gestionar eficientemente los datos relacionados con:

- Clientes y empresas
- Catálogo de productos y servicios
- Georreferenciación de usuarios
- Preferencias y favoritos
- Evaluación de productos mediante encuestas
- Planes de membresía y beneficios asociados
- Métricas de calidad y segmentación por audiencia

## **4. Modelo de Datos y Estructura Relacional**

### 4.1 Estructura Geográfica

El sistema implementa una jerarquía de localización geográfica compuesta por:

- `countries` (países)
- `stateregions` (departamentos o estados)
- `citiesormunicipalities` (ciudades o municipios)

Esta estructura permite realizar segmentaciones geográficas precisas tanto para clientes como empresas, lo cual facilita análisis de mercado y distribución logística.

### 4.2 Gestión de Entidades Principales

- **Empresas (`companies`)**: Se almacenan con información clave como ciudad, tipo, categoría y audiencia objetivo. Pueden estar vinculadas a múltiples productos y recibir evaluaciones.
- **Clientes (`customers`)**: Registran información personal, ubicación y perfil de audiencia, además de su historial de calificaciones y favoritos.

### 4.3 Catálogo de Productos

- **Productos (`products`)**: Incluyen atributos como descripción, precio, categoría e imagen.
- **Relación Empresa-Producto (`companyproducts`)**: Permite que múltiples empresas ofrezcan el mismo producto con precios diferenciados y unidades de medida específicas.

### 4.4 Evaluaciones y Métricas

- **Encuestas (`polls`)**: Formato configurable para evaluar empresas o productos.
- **Valoraciones (`rates`)**: Registro de puntuaciones dadas por clientes a productos de empresas específicas.
- **Calidad de productos (`quality_products`)**: Métricas avanzadas para análisis de satisfacción, asociadas a encuestas y usuarios.

### 4.5 Personalización del Usuario

- **Favoritos (`favorites` y `details_favorites`)**: Permite a los clientes gestionar listas de productos de interés.
- **Audiencias (`audiences`)**: Segmenta a los usuarios por perfil demográfico o preferencial.

### 4.6 Programa de Membresías y Beneficios

- **Membresías (`memberships`)**: Tipologías de planes comerciales ofrecidos a los clientes.
- **Periodos de membresía (`membershipperiods`)**: Definen vigencia y costo de cada plan.
- **Beneficios (`benefits`)**: Accesos o privilegios otorgados por membresía.
- **Relación audiencia-beneficio (`audiencebenefits`)** y membresía-beneficio (`membershipbenefits`) permiten una gestión granular del acceso a ventajas según el perfil del usuario o plan adquirido.

## **5. Normalización y Control de Integridad**

El diseño de la base de datos se encuentra normalizado hasta la Tercera Forma Normal (3FN), lo cual garantiza:

- Eliminación de redundancias
- Integridad semántica de los datos
- Eficiencia en las operaciones de actualización y consulta

Además, todas las relaciones cuentan con restricciones de clave foránea (`FOREIGN KEY`) para asegurar la integridad referencial entre tablas, apoyándose en el motor de almacenamiento **InnoDB** de MySQL.

## **6. Consideraciones Técnicas de Implementación**

- **SGBD**: MySQL 8.x
- **Motor de almacenamiento**: InnoDB
- **Interfaz de administración recomendada**: MySQL Workbench o DBeaver
- **Lenguaje de consultas**: SQL estándar con extensiones propias de MySQL (índices, restricciones, vistas materializadas si se requieren en etapas futuras)

## **7. Escalabilidad y Seguridad**

El modelo permite escalar horizontalmente mediante la adición de nuevas categorías, productos, empresas, zonas geográficas y planes de membresía. La seguridad se garantiza mediante una arquitectura orientada a roles (por implementar en la capa de aplicación) y validaciones a nivel de esquema, tales como claves únicas, restricciones de nulidad y control de longitud de campos.

## **8. Conclusión**

La solución propuesta responde a los requerimientos funcionales y no funcionales de una plataforma de comercialización moderna. El modelo relacional garantiza consistencia, rendimiento y extensibilidad, permitiendo el desarrollo de aplicaciones web o móviles que consuman esta base de datos mediante APIs, análisis de datos o dashboards administrativos. Este sistema sienta las bases para una arquitectura de información sólida, adaptable y preparada para evolucionar hacia entornos distribuidos o microservicios.

# Der Propuesto

https://i.ibb.co/JwMnYkcr/DERPlat-Products.png

![](https://i.ibb.co/JwMnYkcr/DERPlat-Products.png)

# Historias de Usuario

## 🔹 **1. Consultas SQL Especializadas**

1. Como analista, quiero listar todos los productos con su empresa asociada y el precio más bajo por ciudad.
   SELECT cp.product_id, p.name AS product_name, c.name AS company_name, ci.name AS city_name, MIN(cp.price) AS lowest_price
   FROM companyproducts cp
   JOIN products p ON cp.product_id = p.id
   JOIN companies c ON cp.company_id = c.id
   JOIN citiesormunicipalities ci ON c.city_id = ci.code
   GROUP BY cp.product_id, p.name, c.name, ci.name;

2. Como administrador, deseo obtener el top 5 de clientes que más productos han calificado en los últimos 6 meses.

   SELECT cu.id, cu.name, COUNT(*) AS total_ratings
   FROM rates r
   JOIN customers cu ON r.customer_id = cu.id
   WHERE r.daterating >= NOW() - INTERVAL 6 MONTH
   GROUP BY cu.id, cu.name
   ORDER BY total_ratings DESC
   LIMIT 5;

3. Como gerente de ventas, quiero ver la distribución de productos por categoría y unidad de medida.

   SELECT p.category_id, u.description AS unit, COUNT(*) AS total
   FROM companyproducts cp
   JOIN unitofmeasure u ON cp.unitmeasure_id = u.id
   JOIN products p ON cp.product_id = p.id
   GROUP BY p.category_id, u.description;

4. Como cliente, quiero saber qué productos tienen calificaciones superiores al promedio general.

   SELECT p.id, p.name, AVG(r.rating) AS avg_rating
   FROM products p
   JOIN companyproducts cp ON p.id = cp.product_id
   JOIN rates r ON cp.company_id = r.company_id
   GROUP BY p.id, p.name
   HAVING avg_rating > (SELECT AVG(rating) FROM rates);

5. Como auditor, quiero conocer todas las empresas que no han recibido ninguna calificación.

   SELECT c.id, c.name
   FROM companies c
   LEFT JOIN rates r ON c.id = r.company_id
   WHERE r.company_id IS NULL;

6. Como operador, deseo obtener los productos que han sido añadidos como favoritos por más de 10 clientes distintos.

   SELECT df.product_id, COUNT(DISTINCT f.customer_id) AS total_customers
   FROM details_favorites df
   JOIN favorites f ON df.favorite_id = f.id
   GROUP BY df.product_id
   HAVING total_customers > 10;

7. Como gerente regional, quiero obtener todas las empresas activas por ciudad y categoría.

   SELECT city_id, category_id, COUNT(*) AS total
   FROM companies
   GROUP BY city_id, category_id;

8. Como especialista en marketing, deseo obtener los 10 productos más calificados en cada ciudad.

   SELECT cp.product_id, ci.name AS city, COUNT(*) AS total_ratings
   FROM rates r
   JOIN companies c ON r.company_id = c.id
   JOIN companyproducts cp ON cp.company_id = c.id
   JOIN citiesormunicipalities ci ON c.city_id = ci.code
   GROUP BY cp.product_id, ci.name
   ORDER BY total_ratings DESC
   LIMIT 10;

9. Como técnico, quiero identificar productos sin unidad de medida asignada.

   SELECT cp.product_id
   FROM companyproducts cp
   WHERE cp.unitmeasure_id IS NULL;

10. Como gestor de beneficios, deseo ver los planes de membresía sin beneficios registrados.

    SELECT m.id, m.name
    FROM memberships m
    LEFT JOIN membershipbenefits mb ON m.id = mb.membership_id
    WHERE mb.membership_id IS NULL;

11. Como supervisor, quiero obtener los productos de una categoría específica con su promedio de calificación.

    SELECT p.id, p.name, AVG(r.rating) AS promedio
    FROM products p
    JOIN companyproducts cp ON cp.product_id = p.id
    JOIN companies c ON cp.company_id = c.id
    JOIN rates r ON r.company_id = c.id
    WHERE p.category_id = 2
    GROUP BY p.id, p.name;

12. Como asesor, deseo obtener los clientes que han comprado productos de más de una empresa.

    SELECT r.customer_id
    FROM rates r
    GROUP BY r.customer_id
    HAVING COUNT(DISTINCT r.company_id) > 1;

13. Como director, quiero identificar las ciudades con más clientes activos.

    SELECT city_id, COUNT(*) AS total
    FROM customers
    GROUP BY city_id
    ORDER BY total DESC;

14. Como analista de calidad, deseo obtener el ranking de productos por empresa basado en la media de `quality_products`.

    SELECT qp.company_id, qp.product_id, AVG(qp.rating) AS promedio
    FROM quality_products qp
    GROUP BY qp.company_id, qp.product_id
    ORDER BY promedio DESC;

15. Como administrador, quiero listar empresas que ofrecen más de cinco productos distintos.

    SELECT company_id, COUNT(DISTINCT product_id) AS total
    FROM companyproducts
    GROUP BY company_id
    HAVING total > 5;

16. Como cliente, deseo visualizar los productos favoritos que aún no han sido calificados.

    SELECT df.product_id, f.customer_id
    FROM details_favorites df
    JOIN favorites f ON df.favorite_id = f.id
    LEFT JOIN companyproducts cp ON cp.product_id = df.product_id
    LEFT JOIN rates r ON cp.company_id = r.company_id AND f.customer_id = r.customer_id
    WHERE r.company_id IS NULL;

17. Como desarrollador, deseo consultar los beneficios asignados a cada audiencia junto con su descripción.

    SELECT ab.audience_id, b.description, b.detail
    FROM audiencebenefits ab
    JOIN benefits b ON ab.benefit_id = b.id;

18. Como operador logístico, quiero saber en qué ciudades hay empresas sin productos asociados.

    SELECT ci.name
    FROM citiesormunicipalities ci
    JOIN companies c ON ci.code = c.city_id
    LEFT JOIN companyproducts cp ON cp.company_id = c.id
    WHERE cp.product_id IS NULL;

19. Como técnico, deseo obtener todas las empresas con productos duplicados por nombre.

    SELECT c.id, p.name, COUNT(*) AS total
    FROM companies c
    JOIN companyproducts cp ON c.id = cp.company_id
    JOIN products p ON cp.product_id = p.id
    GROUP BY c.id, p.name
    HAVING total > 1;

20. Como analista, quiero una vista resumen de clientes, productos favoritos y promedio de calificación recibido.

     SELECT 
      cu.id AS customer_id,
      cu.name AS customer_name,
      COUNT(DISTINCT df.product_id) AS total_favoritos,
      AVG(r.rating) AS promedio_calificaciones
    FROM customers cu
    LEFT JOIN favorites f ON cu.id = f.customer_id
    LEFT JOIN details_favorites df ON f.id = df.favorite_id
    LEFT JOIN companyproducts cp ON df.product_id = cp.product_id
    LEFT JOIN rates r ON cp.company_id = r.company_id AND cu.id = r.customer_id
    GROUP BY cu.id, cu.name;

------

## 🔹 **2. Subconsultas**

1. Como gerente, quiero ver los productos cuyo precio esté por encima del promedio de su categoría.

   SELECT p.id, p.name, p.price, p.category_id
   FROM products p
   WHERE p.price > (
     SELECT AVG(p2.price)
     FROM products p2
     WHERE p2.category_id = p.category_id
   );

2. Como administrador, deseo listar las empresas que tienen más productos que la media de empresas.

   SELECT company_id, COUNT(*) AS total_productos
   FROM companyproducts
   GROUP BY company_id
   HAVING total_productos > (
     SELECT AVG(productos_por_empresa)
     FROM (
       SELECT COUNT(*) AS productos_por_empresa
       FROM companyproducts
       GROUP BY company_id
     ) AS sub
   );

3. Como cliente, quiero ver mis productos favoritos que han sido calificados por otros clientes.

   SELECT DISTINCT df.product_id
   FROM details_favorites df
   WHERE df.product_id IN (
     SELECT DISTINCT cp.product_id
     FROM companyproducts cp
     JOIN rates r ON cp.company_id = r.company_id
   );

4. Como supervisor, deseo obtener los productos con el mayor número de veces añadidos como favoritos.

   SELECT df.product_id, COUNT(*) AS total_favoritos
   FROM details_favorites df
   GROUP BY df.product_id
   HAVING total_favoritos = (
     SELECT MAX(total)
     FROM (
       SELECT COUNT(*) AS total
       FROM details_favorites
       GROUP BY product_id
     ) AS sub
   );

5. Como técnico, quiero listar los clientes cuyo correo no aparece en la tabla `rates` ni en `quality_products`.

   SELECT c.id, c.name, c.email
   FROM customers c
   WHERE c.email IS NOT NULL
     AND c.id NOT IN (SELECT DISTINCT customer_id FROM rates)
     AND c.id NOT IN (SELECT DISTINCT customer_id FROM quality_products);

6. Como gestor de calidad, quiero obtener los productos con una calificación inferior al mínimo de su categoría.

   SELECT p.id, p.name, AVG(r.rating) AS promedio
   FROM products p
   JOIN companyproducts cp ON p.id = cp.product_id
   JOIN rates r ON cp.company_id = r.company_id
   GROUP BY p.id, p.name, p.category_id
   HAVING promedio < (
     SELECT MIN(sub_prom)
     FROM (
       SELECT AVG(r2.rating) AS sub_prom
       FROM products p2
       JOIN companyproducts cp2 ON p2.id = cp2.product_id
       JOIN rates r2 ON cp2.company_id = r2.company_id
       GROUP BY p2.category_id
     ) AS sub
   );

7. Como desarrollador, deseo listar las ciudades que no tienen clientes registrados.

   SELECT ci.code, ci.name
   FROM citiesormunicipalities ci
   WHERE ci.code NOT IN (
     SELECT DISTINCT city_id
     FROM customers
   );

8. Como administrador, quiero ver los productos que no han sido evaluados en ninguna encuesta.

   SELECT p.id, p.name
   FROM products p
   WHERE p.id NOT IN (
     SELECT DISTINCT cp.product_id
     FROM companyproducts cp
     JOIN rates r ON cp.company_id = r.company_id
   );

9. Como auditor, quiero listar los beneficios que no están asignados a ninguna audiencia.

   SELECT b.id, b.description
   FROM benefits b
   WHERE b.id NOT IN (
     SELECT DISTINCT benefit_id
     FROM audiencebenefits
   );

10. Como cliente, deseo obtener mis productos favoritos que no están disponibles actualmente en ninguna empresa.

    SELECT DISTINCT df.product_id
    FROM details_favorites df
    WHERE df.product_id NOT IN (
      SELECT DISTINCT product_id
      FROM companyproducts
    );

11. Como director, deseo consultar los productos vendidos en empresas cuya ciudad tenga menos de tres empresas registradas.

    SELECT DISTINCT cp.product_id
    FROM companyproducts cp
    JOIN companies c ON cp.company_id = c.id
    WHERE c.city_id IN (
      SELECT city_id
      FROM companies
      GROUP BY city_id
      HAVING COUNT(*) < 3
    );

12. Como analista, quiero ver los productos con calidad superior al promedio de todos los productos.

    SELECT qp.product_id, AVG(qp.rating) AS promedio
    FROM quality_products qp
    GROUP BY qp.product_id
    HAVING promedio > (
      SELECT AVG(rating)
      FROM quality_products
    );

13. Como gestor, quiero ver empresas que sólo venden productos de una única categoría.

    SELECT c.id, c.name
    FROM companies c
    JOIN companyproducts cp ON c.id = cp.company_id
    JOIN products p ON cp.product_id = p.id
    GROUP BY c.id, c.name
    HAVING COUNT(DISTINCT p.category_id) = 1;

14. Como gerente comercial, quiero consultar los productos con el mayor precio entre todas las empresas.

    SELECT cp.product_id, cp.price
    FROM companyproducts cp
    WHERE cp.price = (
      SELECT MAX(price)
      FROM companyproducts
    );

15. Como cliente, quiero saber si algún producto de mis favoritos ha sido calificado por otro cliente con más de 4 estrellas.

    SELECT DISTINCT df.product_id
    FROM details_favorites df
    JOIN companyproducts cp ON df.product_id = cp.product_id
    JOIN rates r ON cp.company_id = r.company_id
    WHERE r.rating > 4;

16. Como operador, quiero saber qué productos no tienen imagen asignada pero sí han sido calificados.

    SELECT DISTINCT p.id, p.name
    FROM products p
    JOIN companyproducts cp ON p.id = cp.product_id
    JOIN rates r ON cp.company_id = r.company_id
    WHERE p.image IS NULL OR p.image = '';

17. Como auditor, quiero ver los planes de membresía sin periodo vigente.

    SELECT m.id, m.name
    FROM memberships m
    WHERE m.id NOT IN (
      SELECT DISTINCT membership_id
      FROM membershipperiods
    );

18. Como especialista, quiero identificar los beneficios compartidos por más de una audiencia.

    SELECT benefit_id
    FROM audiencebenefits
    GROUP BY benefit_id
    HAVING COUNT(DISTINCT audience_id) > 1;

19. Como técnico, quiero encontrar empresas cuyos productos no tengan unidad de medida definida.

    SELECT DISTINCT cp.company_id
    FROM companyproducts cp
    WHERE cp.unitmeasure_id IS NULL;

20. Como gestor de campañas, deseo obtener los clientes con membresía activa y sin productos favoritos.

    SELECT c.id, c.name
    FROM customers c
    WHERE c.id IN (
      SELECT customer_id
      FROM membershipperiods
      WHERE CURDATE() BETWEEN start_date AND end_date
    )
    AND c.id NOT IN (
      SELECT DISTINCT customer_id
      FROM favorites
    );

------

## 🔹 **3. Funciones Agregadas**

1. ### **1. Obtener el promedio de calificación por producto**

   > *"Como analista, quiero obtener el promedio de calificación por producto."*

   🔍 **Explicación para dummies:**
    La persona encargada de revisar el rendimiento quiere saber **qué tan bien calificado está cada producto**. Con `AVG(rating)` agrupado por `product_id`, puede verlo de forma resumida.

   SELECT cp.product_id, AVG(r.rating) AS promedio
   FROM companyproducts cp
   JOIN rates r ON cp.company_id = r.company_id
   GROUP BY cp.product_id;
   
   ------
   
   ### **2. Contar cuántos productos ha calificado cada cliente**

   > *"Como gerente, desea contar cuántos productos ha calificado cada cliente."*

   🔍 **Explicación:**
    Aquí se quiere saber **quiénes están activos opinando**. Se usa `COUNT(*)` sobre `rates`, agrupando por `customer_id`.
   
   SELECT customer_id, COUNT(*) AS total_calificados
   FROM rates
   GROUP BY customer_id;

   ------

   ### **3. Sumar el total de beneficios asignados por audiencia**

   > *"Como auditor, quiere sumar el total de beneficios asignados por audiencia."*

   🔍 **Explicación:**
    El auditor busca **cuántos beneficios tiene cada tipo de usuario**. Con `COUNT(*)` agrupado por `audience_id` en `audiencebenefits`, lo obtiene.

   SELECT audience_id, COUNT(*) AS total_beneficios
   FROM audiencebenefits
   GROUP BY audience_id;

   ------

   ### **4. Calcular la media de productos por empresa**
   
   > *"Como administrador, desea conocer la media de productos por empresa."*
   
   🔍 **Explicación:**
    El administrador quiere saber si **las empresas están ofreciendo pocos o muchos productos**. Cuenta los productos por empresa y saca el promedio con `AVG(cantidad)`.

   SELECT AVG(productos) AS media_productos
   FROM (
     SELECT COUNT(*) AS productos
     FROM companyproducts
     GROUP BY company_id
   ) AS sub;

   ------

   ### **5. Contar el total de empresas por ciudad**

   > *"Como supervisor, quiere ver el total de empresas por ciudad."*
   
   🔍 **Explicación:**
    La idea es ver **en qué ciudades hay más movimiento empresarial**. Se usa `COUNT(*)` en `companies`, agrupando por `city_id`.

   SELECT city_id, COUNT(*) AS total_empresas
   FROM companies
   GROUP BY city_id;

   ------
   
   ### **6. Calcular el promedio de precios por unidad de medida**
   
   > *"Como técnico, desea obtener el promedio de precios de productos por unidad de medida."*
   
   🔍 **Explicación:**
    Se necesita saber si **los precios son coherentes según el tipo de medida**. Con `AVG(price)` agrupado por `unit_id`, se compara cuánto cuesta el litro, kilo, unidad, etc.

   SELECT unitmeasure_id, AVG(price) AS promedio_precio
   FROM companyproducts
   GROUP BY unitmeasure_id;
   
   ------
   
   ### **7. Contar cuántos clientes hay por ciudad**
   
   > *"Como gerente, quiere ver el número de clientes registrados por cada ciudad."*
   
   🔍 **Explicación:**
    Con `COUNT(*)` agrupado por `city_id` en la tabla `customers`, se obtiene **la cantidad de clientes que hay en cada zona**.
   
   SELECT city_id, COUNT(*) AS total_clientes
   FROM customers
   GROUP BY city_id;
   
   ------
   
   ### **8. Calcular planes de membresía por periodo**

   > *"Como operador, desea contar cuántos planes de membresía existen por periodo."*

   🔍 **Explicación:**
    Sirve para ver **qué tantos planes están vigentes cada mes o trimestre**. Se agrupa por periodo (`start_date`, `end_date`) y se cuenta cuántos registros hay.
   
   SELECT period_id, COUNT(*) AS total_planes
   FROM membershipperiods
   GROUP BY period_id;

   ------

   ### **9. Ver el promedio de calificaciones dadas por un cliente a sus favoritos**

   > *"Como cliente, quiere ver el promedio de calificaciones que ha otorgado a sus productos favoritos."*

   🔍 **Explicación:**
    El cliente quiere saber **cómo ha calificado lo que más le gusta**. Se hace un `JOIN` entre favoritos y calificaciones, y se saca `AVG(rating)`.

   SELECT f.customer_id, AVG(r.rating) AS promedio_favoritos
   FROM favorites f
   JOIN details_favorites df ON f.id = df.favorite_id
   JOIN companyproducts cp ON df.product_id = cp.product_id
   JOIN rates r ON cp.company_id = r.company_id AND r.customer_id = f.customer_id
   GROUP BY f.customer_id;
   
   ------

   ### **10. Consultar la fecha más reciente en que se calificó un producto**

   > *"Como auditor, desea obtener la fecha más reciente en la que se calificó un producto."*

   🔍 **Explicación:**
    Busca el `MAX(created_at)` agrupado por producto. Así sabe **cuál fue la última vez que se evaluó cada uno**.
   
   SELECT cp.product_id, MAX(r.daterating) AS ultima_fecha
   FROM companyproducts cp
   JOIN rates r ON cp.company_id = r.company_id
   GROUP BY cp.product_id;
   
   ------
   
   ### **11. Obtener la desviación estándar de precios por categoría**
   
   > *"Como desarrollador, quiere conocer la variación de precios por categoría de producto."*

   🔍 **Explicación:**
    Usando `STDDEV(price)` en `companyproducts` agrupado por `category_id`, se puede ver **si hay mucha diferencia de precios dentro de una categoría**.
   
   SELECT p.category_id, STDDEV(cp.price) AS desviacion
   FROM companyproducts cp
   JOIN products p ON cp.product_id = p.id
   GROUP BY p.category_id;
   
   ------
   
   ### **12. Contar cuántas veces un producto fue favorito**
   
   > *"Como técnico, desea contar cuántas veces un producto fue marcado como favorito."*
   
   🔍 **Explicación:**
    Con `COUNT(*)` en `details_favorites`, agrupado por `product_id`, se obtiene **cuáles productos son los más populares entre los clientes**.
   
   SELECT product_id, COUNT(*) AS total_favoritos
   FROM details_favorites
   GROUP BY product_id;
   
   ------
   
   ### **13. Calcular el porcentaje de productos evaluados**
   
   > *"Como director, quiere saber qué porcentaje de productos han sido calificados al menos una vez."*

   🔍 **Explicación:**
    Cuenta cuántos productos hay en total y cuántos han sido evaluados (`rates`). Luego calcula `(evaluados / total) * 100`.
   
   SELECT 
     (SELECT COUNT(DISTINCT cp.product_id) 
      FROM companyproducts cp
      JOIN rates r ON cp.company_id = r.company_id) * 100.0 / 
     (SELECT COUNT(*) FROM products) AS porcentaje_evaluados;
   
   ------
   
   ### **14. Ver el promedio de rating por encuesta**
   
   > *"Como analista, desea conocer el promedio de rating por encuesta."*
   
   🔍 **Explicación:**
    Agrupa por `poll_id` en `rates`, y calcula el `AVG(rating)` para ver **cómo se comportó cada encuesta**.
   
   SELECT poll_id, AVG(rating) AS promedio
   FROM rates
   GROUP BY poll_id;
   
   ------
   
   ### **15. Calcular el promedio y total de beneficios por plan**
   
   > *"Como gestor, quiere obtener el promedio y el total de beneficios asignados a cada plan de membresía."*
   
   🔍 **Explicación:**
    Agrupa por `membership_id` en `membershipbenefits`, y usa `COUNT(*)` y `AVG(beneficio)` si aplica (si hay ponderación).
   
   SELECT membership_id, COUNT(*) AS total_beneficios
   FROM membershipbenefits
   GROUP BY membership_id;
   
   ------
   
   ### **16. Obtener media y varianza de precios por empresa**
   
   > *"Como gerente, desea obtener la media y la varianza del precio de productos por empresa."*
   
   🔍 **Explicación:**
    Se agrupa por `company_id` y se usa `AVG(price)` y `VARIANCE(price)` para saber **qué tan consistentes son los precios por empresa**.
   
   SELECT company_id, AVG(price) AS media, VARIANCE(price) AS varianza
   FROM companyproducts
   GROUP BY company_id;
   
   ------
   
   ### **17. Ver total de productos disponibles en la ciudad del cliente**
   
   > *"Como cliente, quiere ver cuántos productos están disponibles en su ciudad."*
   
   🔍 **Explicación:**
    Hace un `JOIN` entre `companies`, `companyproducts` y `citiesormunicipalities`, filtrando por la ciudad del cliente. Luego se cuenta.
   
   SELECT cu.city_id, COUNT(DISTINCT cp.product_id) AS productos_disponibles
   FROM customers cu
   JOIN companies co ON cu.city_id = co.city_id
   JOIN companyproducts cp ON co.id = cp.company_id
   GROUP BY cu.city_id;
   
   ------
   
   ### **18. Contar productos únicos por tipo de empresa**
   
   > *"Como administrador, desea contar los productos únicos por tipo de empresa."*
   
   🔍 **Explicación:**
    Agrupa por `company_type_id` y cuenta cuántos productos diferentes tiene cada tipo de empresa.
   
   SELECT type_id, COUNT(DISTINCT cp.product_id) AS productos_unicos
   FROM companies c
   JOIN companyproducts cp ON c.id = cp.company_id
   GROUP BY type_id;
   
   ------
   
   ### **19. Ver total de clientes sin correo electrónico registrado**
   
   > *"Como operador, quiere saber cuántos clientes no han registrado su correo."*
   
   🔍 **Explicación:**
    Filtra `customers WHERE email IS NULL` y hace un `COUNT(*)`. Esto ayuda a mejorar la base de datos para campañas.
   
   SELECT COUNT(*) AS sin_email
   FROM customers
   WHERE email IS NULL OR email = '';
   
   ------
   
   ### **20. Empresa con más productos calificados**
   
   > *"Como especialista, desea obtener la empresa con el mayor número de productos calificados."*
   
   🔍 **Explicación:**
    Hace un `JOIN` entre `companies`, `companyproducts`, y `rates`, agrupa por empresa y usa `COUNT(DISTINCT product_id)`, ordenando en orden descendente y tomando solo el primero.
   
   SELECT r.company_id, COUNT(*) AS total
   FROM rates r
   GROUP BY r.company_id
   ORDER BY total DESC
   LIMIT 1;

------

## 🔹 **4. Procedimientos Almacenados**

1. ### **1. Registrar una nueva calificación y actualizar el promedio**

   > *"Como desarrollador, quiero un procedimiento que registre una calificación y actualice el promedio del producto."*

   🧠 **Explicación:**
    Este procedimiento recibe `product_id`, `customer_id` y `rating`, inserta la nueva fila en `rates`, y recalcula automáticamente el promedio en la tabla `products` (campo `average_rating`).

   DELIMITER $$
   CREATE PROCEDURE registrar_calificacion(
     IN p_product_id INT,
     IN p_customer_id INT,
     IN p_company_id VARCHAR(20),
     IN p_poll_id INT,
     IN p_rating DECIMAL(3,2)
   )
   BEGIN
     INSERT INTO rates (customer_id, company_id, poll_id, daterating, rating)
     VALUES (p_customer_id, p_company_id, p_poll_id, NOW(), p_rating);
   
     -- Aquí podrías recalcular el promedio y guardarlo si hubiera un campo específico
   END$$
   DELIMITER ;
   
   ------

   ### **2. Insertar empresa y asociar productos por defecto**

   > *"Como administrador, deseo un procedimiento para insertar una empresa y asociar productos por defecto."*

   🧠 **Explicación:**
    Este procedimiento inserta una empresa en `companies`, y luego vincula automáticamente productos predeterminados en `companyproducts`.
   
   DELIMITER $$
   CREATE PROCEDURE insertar_empresa_con_productos(
     IN p_id VARCHAR(20),
     IN p_name VARCHAR(80),
     IN p_city_id VARCHAR(6),
     IN p_type_id INT,
     IN p_category_id INT,
     IN p_audience_id INT,
     IN p_cellphone VARCHAR(15),
     IN p_email VARCHAR(80)
   )
   BEGIN
     INSERT INTO companies (id, name, city_id, type_id, category_id, audience_id, cellphone, email)
     VALUES (p_id, p_name, p_city_id, p_type_id, p_category_id, p_audience_id, p_cellphone, p_email);

     INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id)
     SELECT p_id, id, price, 1 FROM products LIMIT 3;
   END$$
   DELIMITER ;

   ------

   ### **3. Añadir producto favorito validando duplicados**

   > *"Como cliente, quiero un procedimiento que añada un producto favorito y verifique duplicados."*

   🧠 **Explicación:**
    Verifica si el producto ya está en favoritos (`details_favorites`). Si no lo está, lo inserta. Evita duplicaciones silenciosamente.

   DELIMITER $$
   CREATE PROCEDURE agregar_favorito(
     IN p_favorite_id INT,
     IN p_product_id INT,
     IN p_category_id INT
   )
   BEGIN
     IF NOT EXISTS (
       SELECT 1 FROM details_favorites
       WHERE favorite_id = p_favorite_id AND product_id = p_product_id
     ) THEN
       INSERT INTO details_favorites (favorite_id, product_id, category_id)
       VALUES (p_favorite_id, p_product_id, p_category_id);
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### **4. Generar resumen mensual de calificaciones por empresa**
   
   > *"Como gestor, deseo un procedimiento que genere un resumen mensual de calificaciones por empresa."*
   
   🧠 **Explicación:**
    Hace una consulta agregada con `AVG(rating)` por empresa, y guarda los resultados en una tabla de resumen tipo `resumen_calificaciones`.
   
   DELIMITER $$
   CREATE PROCEDURE resumen_calificaciones()
   BEGIN
     SELECT company_id, AVG(rating) AS promedio, COUNT(*) AS total
     FROM rates
     GROUP BY company_id;
   END$$
   DELIMITER ;
   
   ------
   
   ### **5. Calcular beneficios activos por membresía**
   
   > *"Como supervisor, quiero un procedimiento que calcule beneficios activos por membresía."*
   
   🧠 **Explicación:**
    Consulta `membershipbenefits` junto con `membershipperiods`, y devuelve una lista de beneficios vigentes según la fecha actual.
   
   DELIMITER $$
   CREATE PROCEDURE beneficios_activos()
   BEGIN
     SELECT m.id, m.name, b.description
     FROM memberships m
     JOIN membershipbenefits mb ON m.id = mb.membership_id
     JOIN benefits b ON mb.benefit_id = b.id;
   END$$
   DELIMITER ;

   ------

   ### **6. Eliminar productos huérfanos**

   > *"Como técnico, deseo un procedimiento que elimine productos sin calificación ni empresa asociada."*

   🧠 **Explicación:**
    Elimina productos de la tabla `products` que no tienen relación ni en `rates` ni en `companyproducts`.

   CREATE PROCEDURE eliminar_productos_huerfanos()
   BEGIN
     DELETE FROM products
     WHERE id NOT IN (SELECT product_id FROM companyproducts)
       AND id NOT IN (
         SELECT DISTINCT cp.product_id
         FROM companyproducts cp
         JOIN rates r ON cp.company_id = r.company_id
       );
   END$$
   DELIMITER ;
   
   ------
   
   ### **7. Actualizar precios de productos por categoría**
   
   > *"Como operador, quiero un procedimiento que actualice precios de productos por categoría."*

   🧠 **Explicación:**
    Recibe un `categoria_id` y un `factor` (por ejemplo 1.05), y multiplica todos los precios por ese factor en la tabla `companyproducts`.
   
   DELIMITER $$
   CREATE PROCEDURE actualizar_precio_categoria(IN p_categoria_id INT, IN p_factor DECIMAL(4,2))
   BEGIN
     UPDATE companyproducts
     SET price = price * p_factor
     WHERE product_id IN (
       SELECT id FROM products WHERE category_id = p_categoria_id
     );
   END$$
   DELIMITER ;
   
   ------
   
   ### **8. Validar inconsistencia entre `rates` y `quality_products`**

   > *"Como auditor, deseo un procedimiento que liste inconsistencias entre `rates` y `quality_products`."*

   🧠 **Explicación:**
    Busca calificaciones (`rates`) que no tengan entrada correspondiente en `quality_products`. Inserta el error en una tabla `errores_log`.
   
   DELIMITER $$
   CREATE PROCEDURE validar_inconsistencias()
   BEGIN
     SELECT * FROM rates
     WHERE (company_id, customer_id, poll_id)
     NOT IN (
       SELECT company_id, customer_id, poll_id FROM quality_products
     );
   END$$
   DELIMITER ;
   
   ------
   
   ### **9. Asignar beneficios a nuevas audiencias**
   
   > *"Como desarrollador, quiero un procedimiento que asigne beneficios a nuevas audiencias."*
   
   🧠 **Explicación:**
    Recibe un `benefit_id` y `audience_id`, verifica si ya existe el registro, y si no, lo inserta en `audiencebenefits`.
   
   DELIMITER $$
   CREATE PROCEDURE asignar_beneficio_audiencia(IN p_benefit_id INT, IN p_audience_id INT)
   BEGIN
     IF NOT EXISTS (
       SELECT 1 FROM audiencebenefits
       WHERE benefit_id = p_benefit_id AND audience_id = p_audience_id
     ) THEN
       INSERT INTO audiencebenefits (benefit_id, audience_id)
       VALUES (p_benefit_id, p_audience_id);
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### **10. Activar planes de membresía vencidos con pago confirmado**
   
   > *"Como administrador, deseo un procedimiento que active planes de membresía vencidos si el pago fue confirmado."*
   
   🧠 **Explicación:**
    Actualiza el campo `status` a `'ACTIVA'` en `membershipperiods` donde la fecha haya vencido pero el campo `pago_confirmado` sea `TRUE`.
   
   DELIMITER $$
   CREATE PROCEDURE activar_planes_vencidos()
   BEGIN
     UPDATE membershipperiods
     SET status = 'ACTIVA'
     WHERE end_date < CURDATE() AND pago_confirmado = TRUE;
   END$$
   DELIMITER ;
   
   ------
   
   ### **11. Listar productos favoritos del cliente con su calificación**
   
   > *"Como cliente, deseo un procedimiento que me devuelva todos mis productos favoritos con su promedio de rating."*
   
   🧠 **Explicación:**
    Consulta todos los productos favoritos del cliente y muestra el promedio de calificación de cada uno, uniendo `favorites`, `rates` y `products`.
   
   DELIMITER $$
   CREATE PROCEDURE favoritos_con_rating(IN p_customer_id INT)
   BEGIN
     SELECT df.product_id, AVG(r.rating) AS promedio
     FROM favorites f
     JOIN details_favorites df ON f.id = df.favorite_id
     JOIN companyproducts cp ON df.product_id = cp.product_id
     LEFT JOIN rates r ON cp.company_id = r.company_id AND f.customer_id = r.customer_id
     WHERE f.customer_id = p_customer_id
     GROUP BY df.product_id;
   END$$
   DELIMITER ;
   
   ------
   
   ### **12. Registrar encuesta y sus preguntas asociadas**
   
   > *"Como gestor, quiero un procedimiento que registre una encuesta y sus preguntas asociadas."*
   
   🧠 **Explicación:**
    Inserta la encuesta principal en `polls` y luego cada una de sus preguntas en otra tabla relacionada como `poll_questions`.
   
   DELIMITER $$
   CREATE PROCEDURE registrar_encuesta(IN p_name VARCHAR(80), IN p_description TEXT)
   BEGIN
     INSERT INTO polls (name, description, isactive)
     VALUES (p_name, p_description, TRUE);
   END$$
   DELIMITER ;
   
   ------
   
   ### **13. Eliminar favoritos antiguos sin calificaciones**
   
   > *"Como técnico, deseo un procedimiento que borre favoritos antiguos no calificados en más de un año."*
   
   🧠 **Explicación:**
    Filtra productos favoritos que no tienen calificaciones recientes y fueron añadidos hace más de 12 meses, y los elimina de `details_favorites`.
   
   DELIMITER $$
   CREATE PROCEDURE borrar_favoritos_antiguos()
   BEGIN
     DELETE df FROM details_favorites df
     JOIN favorites f ON df.favorite_id = f.id
     LEFT JOIN companyproducts cp ON df.product_id = cp.product_id
     LEFT JOIN rates r ON cp.company_id = r.company_id AND f.customer_id = r.customer_id
     WHERE r.rating IS NULL AND f.id IN (
       SELECT id FROM favorites WHERE DATEDIFF(NOW(), created_at) > 365
     );
   END$$
   DELIMITER ;
   
   ------
   
   ### **14. Asociar beneficios automáticamente por audiencia**
   
   > *"Como operador, quiero un procedimiento que asocie automáticamente beneficios por audiencia."*
   
   🧠 **Explicación:**
    Inserta en `audiencebenefits` todos los beneficios que apliquen según una lógica predeterminada (por ejemplo, por tipo de usuario).
   
   DELIMITER $$
   CREATE PROCEDURE asociar_beneficios_auto()
   BEGIN
     INSERT INTO audiencebenefits (audience_id, benefit_id)
     SELECT id, 1 FROM audiences
     WHERE id NOT IN (
       SELECT audience_id FROM audiencebenefits WHERE benefit_id = 1
     );
   END$$
   DELIMITER ;
   
   ------
   
   ### **15. Historial de cambios de precio**
   
   > *"Como administrador, deseo un procedimiento para generar un historial de cambios de precio."*
   
   🧠 **Explicación:**
    Cada vez que se cambia un precio, el procedimiento compara el anterior con el nuevo y guarda un registro en una tabla `historial_precios`.
   
   DELIMITER $$
   CREATE PROCEDURE registrar_historial_precios()
   BEGIN
     INSERT INTO historial_precios (product_id, precio_anterior, precio_nuevo, fecha)
     SELECT cp.product_id, cp.price, cp.price * 1.1, NOW()
     FROM companyproducts cp;
   END$$
   DELIMITER ;
   
   ------
   
   ### **16. Registrar encuesta activa automáticamente**
   
   > *"Como desarrollador, quiero un procedimiento que registre automáticamente una nueva encuesta activa."*
   
   🧠 **Explicación:**
    Inserta una encuesta en `polls` con el campo `status = 'activa'` y una fecha de inicio en `NOW()`.
   
   DELIMITER $$
   CREATE PROCEDURE encuesta_activa_auto(IN p_name VARCHAR(80), IN p_description TEXT)
   BEGIN
     INSERT INTO polls (name, description, isactive)
     VALUES (p_name, p_description, TRUE);
   END$$
   DELIMITER ;
   
   ------
   
   ### **17. Actualizar unidad de medida de productos sin afectar ventas**
   
   > *"Como técnico, deseo un procedimiento que actualice la unidad de medida de productos sin afectar si hay ventas."*
   
   🧠 **Explicación:**
    Verifica si el producto no ha sido vendido, y si es así, permite actualizar su `unit_id`.
   
   DELIMITER $$
   CREATE PROCEDURE actualizar_unidad_medida_producto(IN p_product_id INT, IN p_new_unit_id INT)
   BEGIN
     IF NOT EXISTS (
       SELECT 1 FROM sales WHERE product_id = p_product_id
     ) THEN
       UPDATE companyproducts
       SET unitmeasure_id = p_new_unit_id
       WHERE product_id = p_product_id;
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### **18. Recalcular promedios de calidad semanalmente**
   
   > *"Como supervisor, quiero un procedimiento que recalcule todos los promedios de calidad cada semana."*
   
   🧠 **Explicación:**
    Hace un `AVG(rating)` agrupado por producto y lo actualiza en `products`.
   
   DELIMITER $$
   CREATE PROCEDURE recalcular_promedios_calidad()
   BEGIN
     UPDATE products p
     JOIN (
       SELECT cp.product_id, AVG(r.rating) AS promedio
       FROM companyproducts cp
       JOIN rates r ON cp.company_id = r.company_id
       GROUP BY cp.product_id
     ) qp ON p.id = qp.product_id
     SET p.average_rating = qp.promedio;
   END$$
   DELIMITER ;
   
   ------
   
   ### **19. Validar claves foráneas entre calificaciones y encuestas**
   
   > *"Como auditor, deseo un procedimiento que valide claves foráneas cruzadas entre calificaciones y encuestas."*
   
   🧠 **Explicación:**
    Busca registros en `rates` con `poll_id` que no existen en `polls`, y los reporta.
   
   DELIMITER $$
   CREATE PROCEDURE validar_claves_foreign_rates_polls()
   BEGIN
     SELECT r.*
     FROM rates r
     WHERE r.poll_id NOT IN (SELECT id FROM polls);
   END$$
   DELIMITER ;
   
   ------
   
   ### **20. Generar el top 10 de productos más calificados por ciudad**
   
   > *"Como gerente, quiero un procedimiento que genere el top 10 de productos más calificados por ciudad."*
   
   🧠 **Explicación:**
    Agrupa las calificaciones por ciudad (a través de la empresa que lo vende) y selecciona los 10 productos con más evaluaciones.
   
   DELIMITER $$
   CREATE PROCEDURE top10_productos_por_ciudad()
   BEGIN
     SELECT ci.name AS ciudad, cp.product_id, COUNT(*) AS total_calificaciones
     FROM rates r
     JOIN companies c ON r.company_id = c.id
     JOIN citiesormunicipalities ci ON c.city_id = ci.code
     JOIN companyproducts cp ON cp.company_id = c.id
     GROUP BY ci.name, cp.product_id
     ORDER BY ci.name, total_calificaciones DESC
     LIMIT 10;
   END$$
   DELIMITER ;

------

## 🔹 **5. Triggers**

1. ### 🔎 **1. Actualizar la fecha de modificación de un producto**

   > "Como desarrollador, deseo un trigger que actualice la fecha de modificación cuando se actualice un producto."

   🧠 **Explicación:**
    Cada vez que se actualiza un producto, queremos que el campo `updated_at` se actualice automáticamente con la fecha actual (`NOW()`), sin tener que hacerlo manualmente desde la app.

   🔁 Se usa un `BEFORE UPDATE`.

   DELIMITER $$
   CREATE TRIGGER actualizar_fecha_modificacion_producto
   BEFORE UPDATE ON products
   FOR EACH ROW
   BEGIN
     SET NEW.updated_at = NOW();
   END$$
   DELIMITER ;

   ------

   ### 🔎 **2. Registrar log cuando un cliente califica un producto**

   > "Como administrador, quiero un trigger que registre en log cuando un cliente califica un producto."

   🧠 **Explicación:**
    Cuando alguien inserta una fila en `rates`, el trigger crea automáticamente un registro en `log_acciones` con la información del cliente y producto calificado.
   
   🔁 Se usa un `AFTER INSERT` sobre `rates`.

   DELIMITER $$
   CREATE TRIGGER log_calificacion_cliente
   AFTER INSERT ON rates
   FOR EACH ROW
   BEGIN
     INSERT INTO log_acciones (accion, customer_id, company_id, fecha)
     VALUES ('Calificación registrada', NEW.customer_id, NEW.company_id, NOW());
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **3. Impedir insertar productos sin unidad de medida**
   
   > "Como técnico, deseo un trigger que impida insertar productos sin unidad de medida."
   
   🧠 **Explicación:**
    Antes de guardar un nuevo producto, el trigger revisa si `unit_id` es `NULL`. Si lo es, lanza un error con `SIGNAL`.

   🔁 Se usa un `BEFORE INSERT`.
   
   DELIMITER $$
   CREATE TRIGGER validar_unidad_producto
   BEFORE INSERT ON companyproducts
   FOR EACH ROW
   BEGIN
     IF NEW.unitmeasure_id IS NULL THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'No se puede insertar un producto sin unidad de medida.';
     END IF;
   END$$
   DELIMITER ;

   ------

   ### 🔎 **4. Validar calificaciones no mayores a 5**

   > "Como auditor, quiero un trigger que verifique que las calificaciones no superen el valor máximo permitido."

   🧠 **Explicación:**
    Si alguien intenta insertar una calificación de 6 o más, se bloquea automáticamente. Esto evita errores o trampa.
   
   🔁 Se usa un `BEFORE INSERT`.

   DELIMITER $$
   CREATE TRIGGER validar_max_calificacion
   BEFORE INSERT ON rates
   FOR EACH ROW
   BEGIN
     IF NEW.rating > 5 THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'La calificación no puede ser mayor a 5.';
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **5. Actualizar estado de membresía cuando vence**
   
   > "Como supervisor, deseo un trigger que actualice automáticamente el estado de membresía al vencer el periodo."
   
   🧠 **Explicación:**
    Cuando se actualiza un periodo de membresía (`membershipperiods`), si `end_date` ya pasó, se puede cambiar el campo `status` a 'INACTIVA'.
   
   🔁 `AFTER UPDATE` o `BEFORE UPDATE` dependiendo de la lógica.
   
   DELIMITER $$
   CREATE TRIGGER actualizar_estado_membresia
   BEFORE UPDATE ON membershipperiods
   FOR EACH ROW
   BEGIN
     IF NEW.end_date < CURDATE() THEN
       SET NEW.status = 'INACTIVA';
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **6. Evitar duplicados de productos por empresa**
   
   > "Como operador, quiero un trigger que evite duplicar productos por nombre dentro de una misma empresa."
   
   🧠 **Explicación:**
    Antes de insertar un nuevo producto en `companyproducts`, el trigger puede consultar si ya existe uno con el mismo `product_id` y `company_id`.
   
   🔁 `BEFORE INSERT`.
   
   DELIMITER $$
   CREATE TRIGGER evitar_duplicados_empresa_producto
   BEFORE INSERT ON companyproducts
   FOR EACH ROW
   BEGIN
     IF EXISTS (
       SELECT 1 FROM companyproducts
       WHERE company_id = NEW.company_id AND product_id = NEW.product_id
     ) THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'El producto ya está registrado para esta empresa.';
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **7. Enviar notificación al añadir un favorito**

   > "Como cliente, deseo un trigger que envíe notificación cuando añado un producto como favorito."

   🧠 **Explicación:**
    Después de un `INSERT` en `details_favorites`, el trigger agrega un mensaje a una tabla `notificaciones`.
   
   🔁 `AFTER INSERT`.
   
   DELIMITER $$
   CREATE TRIGGER notificar_favorito_nuevo
   AFTER INSERT ON details_favorites
   FOR EACH ROW
   BEGIN
     INSERT INTO notificaciones (mensaje, fecha)
     VALUES (CONCAT('Se añadió un nuevo favorito: ', NEW.product_id), NOW());
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **8. Insertar fila en `quality_products` tras calificación**
   
   > "Como técnico, quiero un trigger que inserte una fila en `quality_products` cuando se registra una calificación."
   
   🧠 **Explicación:**
    Al insertar una nueva calificación en `rates`, se crea automáticamente un registro en `quality_products` para mantener métricas de calidad.
   
   🔁 `AFTER INSERT`.
   
   DELIMITER $$
   CREATE TRIGGER insertar_quality_al_calificar
   AFTER INSERT ON rates
   FOR EACH ROW
   BEGIN
     INSERT INTO quality_products (product_id, customer_id, company_id, poll_id, rating)
     SELECT cp.product_id, NEW.customer_id, NEW.company_id, NEW.poll_id, NEW.rating
     FROM companyproducts cp
     WHERE cp.company_id = NEW.company_id
     LIMIT 1;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **9. Eliminar favoritos si se elimina el producto**

   > "Como desarrollador, deseo un trigger que elimine los favoritos si se elimina el producto."

   🧠 **Explicación:**
    Cuando se borra un producto, el trigger elimina las filas en `details_favorites` donde estaba ese producto.
   
   🔁 `AFTER DELETE` en `products`.
   
   DELIMITER $$
   CREATE TRIGGER eliminar_favoritos_si_producto
   AFTER DELETE ON products
   FOR EACH ROW
   BEGIN
     DELETE FROM details_favorites WHERE product_id = OLD.id;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **10. Bloquear modificación de audiencias activas**
   
   > "Como administrador, quiero un trigger que bloquee la modificación de audiencias activas."
   
   🧠 **Explicación:**
    Si un usuario intenta modificar una audiencia que está en uso, el trigger lanza un error con `SIGNAL`.
   
   🔁 `BEFORE UPDATE`.
   
   DELIMITER $$
   CREATE TRIGGER bloquear_update_audiencias_activas
   BEFORE UPDATE ON audiences
   FOR EACH ROW
   BEGIN
     IF OLD.isactive = TRUE THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'No se puede modificar una audiencia activa.';
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **11. Recalcular promedio de calidad del producto tras nueva evaluación**
   
   > "Como gestor, deseo un trigger que actualice el promedio de calidad del producto tras una nueva evaluación."
   
   🧠 **Explicación:**
    Después de insertar en `rates`, el trigger actualiza el campo `average_rating` del producto usando `AVG()`.
   
   🔁 `AFTER INSERT`.
   
   DELIMITER $$
   CREATE TRIGGER recalcular_promedio_calidad
   AFTER INSERT ON rates
   FOR EACH ROW
   BEGIN
     UPDATE products p
     JOIN companyproducts cp ON cp.product_id = p.id
     SET p.average_rating = (
       SELECT AVG(r.rating)
       FROM companyproducts cp2
       JOIN rates r ON cp2.company_id = r.company_id
       WHERE cp2.product_id = cp.product_id
     )
     WHERE cp.company_id = NEW.company_id;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **12. Registrar asignación de nuevo beneficio**
   
   > "Como auditor, quiero un trigger que registre cada vez que se asigna un nuevo beneficio."
   
   🧠 **Explicación:**
    Cuando se hace `INSERT` en `membershipbenefits` o `audiencebenefits`, se agrega un log en `bitacora`.
   
   DELIMITER $$
   CREATE TRIGGER log_asignacion_beneficio
   AFTER INSERT ON membershipbenefits
   FOR EACH ROW
   BEGIN
     INSERT INTO bitacora (evento, fecha)
     VALUES ('Nuevo beneficio asignado', NOW());
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **13. Impedir doble calificación por parte del cliente**
   
   > "Como cliente, deseo un trigger que me impida calificar el mismo producto dos veces seguidas."
   
   🧠 **Explicación:**
    Antes de insertar en `rates`, el trigger verifica si ya existe una calificación de ese `customer_id` y `product_id`.
   
   DELIMITER $$
   CREATE TRIGGER evitar_doble_calificacion
   BEFORE INSERT ON rates
   FOR EACH ROW
   BEGIN
     IF EXISTS (
       SELECT 1 FROM rates
       WHERE customer_id = NEW.customer_id
         AND poll_id = NEW.poll_id
         AND company_id = NEW.company_id
     ) THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'El cliente ya calificó esta encuesta para esa empresa.';
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **14. Validar correos duplicados en clientes**
   
   > "Como técnico, quiero un trigger que valide que el email del cliente no se repita."
   
   🧠 **Explicación:**
    Verifica, antes del `INSERT`, si el correo ya existe en la tabla `customers`. Si sí, lanza un error.
   
   DELIMITER $$
   CREATE TRIGGER validar_correo_duplicado
   BEFORE INSERT ON customers
   FOR EACH ROW
   BEGIN
     IF EXISTS (
       SELECT 1 FROM customers WHERE email = NEW.email
     ) THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'El correo ya está registrado.';
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **15. Eliminar detalles de favoritos huérfanos**
   
   > "Como operador, deseo un trigger que elimine registros huérfanos de `details_favorites`."
   
   🧠 **Explicación:**
    Si se elimina un registro de `favorites`, se borran automáticamente sus detalles asociados.
   
   DELIMITER $$
   CREATE TRIGGER eliminar_detalles_favoritos
   AFTER DELETE ON favorites
   FOR EACH ROW
   BEGIN
     DELETE FROM details_favorites WHERE favorite_id = OLD.id;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **16. Actualizar campo `updated_at` en `companies`**
   
   > "Como administrador, quiero un trigger que actualice el campo `updated_at` en `companies`."
   
   🧠 **Explicación:**
    Como en productos, actualiza automáticamente la fecha de última modificación cada vez que se cambia algún dato.
   
   DELIMITER $$
   CREATE TRIGGER actualizar_updated_at_companies
   BEFORE UPDATE ON companies
   FOR EACH ROW
   BEGIN
     SET NEW.updated_at = NOW();
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **17. Impedir borrar ciudad si hay empresas activas**
   
   > "Como desarrollador, deseo un trigger que impida borrar una ciudad si hay empresas activas en ella."
   
   🧠 **Explicación:**
    Antes de hacer `DELETE` en `citiesormunicipalities`, el trigger revisa si hay empresas registradas en esa ciudad.
   
   DELIMITER $$
   CREATE TRIGGER impedir_borrado_ciudad_con_empresas
   BEFORE DELETE ON citiesormunicipalities
   FOR EACH ROW
   BEGIN
     IF EXISTS (
       SELECT 1 FROM companies WHERE city_id = OLD.code
     ) THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'No se puede eliminar una ciudad con empresas registradas.';
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **18. Registrar cambios de estado en encuestas**
   
   > "Como auditor, quiero un trigger que registre cambios de estado de encuestas."
   
   🧠 **Explicación:**
    Cada vez que se actualiza el campo `status` en `polls`, el trigger guarda la fecha, nuevo estado y usuario en un log.
   
   DELIMITER $$
   CREATE TRIGGER log_estado_encuesta
   AFTER UPDATE ON polls
   FOR EACH ROW
   BEGIN
     IF OLD.isactive <> NEW.isactive THEN
       INSERT INTO encuesta_log (poll_id, nuevo_estado, fecha)
       VALUES (NEW.id, NEW.isactive, NOW());
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **19. Sincronizar `rates` y `quality_products`**
   
   > "Como supervisor, deseo un trigger que sincronice `rates` con `quality_products` al calificar."
   
   🧠 **Explicación:**
    Inserta o actualiza la calidad del producto en `quality_products` cada vez que se inserta una nueva calificación.
   
   DELIMITER $$
   CREATE TRIGGER sincronizar_rates_quality
   AFTER INSERT ON rates
   FOR EACH ROW
   BEGIN
     IF NOT EXISTS (
       SELECT 1 FROM quality_products
       WHERE customer_id = NEW.customer_id AND poll_id = NEW.poll_id AND company_id = NEW.company_id
     ) THEN
       INSERT INTO quality_products (product_id, customer_id, company_id, poll_id, rating)
       SELECT cp.product_id, NEW.customer_id, NEW.company_id, NEW.poll_id, NEW.rating
       FROM companyproducts cp
       WHERE cp.company_id = NEW.company_id
       LIMIT 1;
     END IF;
   END$$
   DELIMITER ;
   
   ------
   
   ### 🔎 **20. Eliminar productos sin relación a empresas**
   
   > "Como operador, quiero un trigger que elimine automáticamente productos sin relación a empresas."
   
   🧠 **Explicación:**
    Después de borrar la última relación entre un producto y una empresa (`companyproducts`), el trigger puede eliminar ese producto.
   
   DELIMITER $$
   CREATE TRIGGER eliminar_productos_sin_empresa
   AFTER DELETE ON companyproducts
   FOR EACH ROW
   BEGIN
     IF NOT EXISTS (
       SELECT 1 FROM companyproducts WHERE product_id = OLD.product_id
     ) THEN
       DELETE FROM products WHERE id = OLD.product_id;
     END IF;
   END$$
   DELIMITER ;

------

## 🔹 **6. Events (Eventos Programados..Usar procedimientos o funciones para cada evento)**

1. ## 🔹 **1. Borrar productos sin actividad cada 6 meses**

   > **Historia:** Como administrador, quiero un evento que borre productos sin actividad cada 6 meses.

   🧠 **Explicación:**
    Algunos productos pueden haber sido creados pero nunca calificados, marcados como favoritos ni asociados a una empresa. Este evento eliminaría esos productos cada 6 meses.

   🛠️ **Se usaría un `DELETE`** sobre `products` donde no existan registros en `rates`, `favorites` ni `companyproducts`.

   📅 **Frecuencia del evento:** `EVERY 6 MONTH`

   CREATE EVENT IF NOT EXISTS borrar_productos_sin_actividad
   ON SCHEDULE EVERY 6 MONTH
   DO
   DELETE FROM products
   WHERE id NOT IN (
       SELECT DISTINCT cp.product_id 
       FROM companyproducts cp 
       JOIN rates r ON cp.company_id = r.company_id
   )
     AND id NOT IN (SELECT product_id FROM companyproducts)
     AND id NOT IN (
       SELECT df.product_id
       FROM details_favorites df
       JOIN favorites f ON df.favorite_id = f.id
     );
   
   ------
   
   ## 🔹 **2. Recalcular el promedio de calificaciones semanalmente**
   
   > **Historia:** Como supervisor, deseo un evento semanal que recalcula el promedio de calificaciones.

   🧠 **Explicación:**
    Se puede tener una tabla `product_metrics` que almacena promedios pre-calculados para rapidez. El evento actualizaría esa tabla con nuevos promedios.
   
   🛠️ **Usa `UPDATE` con `AVG(rating)` agrupado por producto.**
   
   📅 Frecuencia: `EVERY 1 WEEK`
   
   CREATE EVENT IF NOT EXISTS recalcular_promedios_semanal
   ON SCHEDULE EVERY 1 WEEK
   DO
   UPDATE product_metrics pm
   JOIN (
     SELECT cp.product_id, AVG(r.rating) AS promedio
     FROM companyproducts cp
     JOIN rates r ON cp.company_id = r.company_id
     GROUP BY cp.product_id
   ) r_avg ON pm.product_id = r_avg.product_id
   SET pm.promedio_rating = r_avg.promedio;

   ------

   ## 🔹 **3. Actualizar precios según inflación mensual**
   
   > **Historia:** Como operador, quiero un evento mensual que actualice los precios de productos por inflación.
   
   🧠 **Explicación:**
    Aplicar un porcentaje de aumento (por ejemplo, 3%) a los precios de todos los productos.

   🛠️ `UPDATE companyproducts SET price = price * 1.03;`

   📅 Frecuencia: `EVERY 1 MONTH`

   CREATE EVENT IF NOT EXISTS actualizar_precios_inflacion
   ON SCHEDULE EVERY 1 MONTH
   DO
   UPDATE companyproducts
   SET price = price * 1.03;
   
   -- EVENT 4: Crear backups lógicos diariamente
   CREATE EVENT IF NOT EXISTS backup_logico_diario
   ON SCHEDULE EVERY 1 DAY STARTS CURRENT_DATE
   DO
   BEGIN
     INSERT INTO products_backup SELECT * FROM products;
     INSERT INTO rates_backup SELECT * FROM rates;
   END;
   
   ------
   
   ## 🔹 **4. Crear backups lógicos diariamente**
   
   > **Historia:** Como auditor, deseo un evento que genere un backup lógico cada medianoche.
   
   🧠 **Explicación:**
    Este evento no ejecuta comandos del sistema, pero puede volcar datos clave a una tabla temporal o de respaldo (`products_backup`, `rates_backup`, etc.).

   📅 `EVERY 1 DAY STARTS '00:00:00'`
   
   ------
   
   ## 🔹 **5. Notificar sobre productos favoritos sin calificar**
   
   > **Historia:** Como cliente, quiero un evento que me recuerde los productos que tengo en favoritos y no he calificado.
   
   🧠 **Explicación:**
    Genera una lista (`user_reminders`) de `product_id` donde el cliente tiene el producto en favoritos pero no hay `rate`.

   🛠️ Requiere `INSERT INTO recordatorios` usando un `LEFT JOIN` y `WHERE rate IS NULL`.
   
   CREATE EVENT IF NOT EXISTS notificar_favoritos_sin_calificar
   ON SCHEDULE EVERY 1 WEEK
   DO
   INSERT INTO recordatorios (customer_id, product_id)
   SELECT f.customer_id, df.product_id
   FROM favorites f
   JOIN details_favorites df ON f.id = df.favorite_id
   JOIN companyproducts cp ON df.product_id = cp.product_id
   LEFT JOIN rates r ON r.company_id = cp.company_id AND r.customer_id = f.customer_id
   WHERE r.rating IS NULL;
   
   ------
   
   ## 🔹 **6. Revisar inconsistencias entre empresa y productos**
   
   > **Historia:** Como técnico, deseo un evento que revise inconsistencias entre empresas y productos cada domingo.
   
   🧠 **Explicación:**
    Detecta productos sin empresa, o empresas sin productos, y los registra en una tabla de anomalías.
   
   🛠️ Puede usar `NOT EXISTS` y `JOIN` para llenar una tabla `errores_log`.
   
   📅 `EVERY 1 WEEK ON SUNDAY`
   
   CREATE EVENT IF NOT EXISTS revisar_inconsistencias_empresas
   ON SCHEDULE EVERY 1 WEEK STARTS CURRENT_DATE + INTERVAL 1 DAY
   DO
   INSERT INTO errores_log (descripcion)
   SELECT CONCAT('Producto sin empresa: ', p.id)
   FROM products p
   WHERE p.id NOT IN (SELECT product_id FROM companyproducts);

   ------

   ## 🔹 **7. Archivar membresías vencidas diariamente**

   > **Historia:** Como administrador, quiero un evento que archive membresías vencidas.

   🧠 **Explicación:**
    Cambia el estado de la membresía cuando su `end_date` ya pasó.

   🛠️ `UPDATE membershipperiods SET status = 'INACTIVA' WHERE end_date < CURDATE();`

   CREATE EVENT IF NOT EXISTS archivar_membresias_vencidas
   ON SCHEDULE EVERY 1 DAY
   DO
   UPDATE membershipperiods
   SET status = 'INACTIVA'
   WHERE end_date < CURDATE();

   ------

   ## 🔹 **8. Notificar beneficios nuevos a usuarios semanalmente**

   > **Historia:** Como supervisor, deseo un evento que notifique por correo sobre beneficios nuevos.

   🧠 **Explicación:**
    Detecta registros nuevos en la tabla `benefits` desde la última semana y los inserta en `notificaciones`.

   🛠️ `INSERT INTO notificaciones SELECT ... WHERE created_at >= NOW() - INTERVAL 7 DAY`

   CREATE EVENT IF NOT EXISTS notificar_nuevos_beneficios
   ON SCHEDULE EVERY 1 WEEK
   DO
   INSERT INTO notificaciones (mensaje)
   SELECT CONCAT('Nuevo beneficio disponible: ', name)
   FROM benefits
   WHERE created_at >= NOW() - INTERVAL 7 DAY;
   
   ------
   
   ## 🔹 **9. Calcular cantidad de favoritos por cliente mensualmente**
   
   > **Historia:** Como operador, quiero un evento que calcule el total de favoritos por cliente y lo guarde.
   
   🧠 **Explicación:**
    Cuenta los productos favoritos por cliente y guarda el resultado en una tabla de resumen mensual (`favoritos_resumen`).
   
   🛠️ `INSERT INTO favoritos_resumen SELECT customer_id, COUNT(*) ... GROUP BY customer_id`
   
   CREATE EVENT IF NOT EXISTS resumen_favoritos_mensual
   ON SCHEDULE EVERY 1 MONTH
   DO
   INSERT INTO favoritos_resumen (customer_id, total)
   SELECT f.customer_id, COUNT(*) 
   FROM details_favorites df
   JOIN favorites f ON df.favorite_id = f.id
   GROUP BY f.customer_id;
   
   ------
   
   ## 🔹 **10. Validar claves foráneas semanalmente**
   
   > **Historia:** Como auditor, deseo un evento que valide claves foráneas semanalmente y reporte errores.

   🧠 **Explicación:**
    Comprueba que cada `product_id`, `customer_id`, etc., tengan correspondencia en sus tablas. Si no, se registra en una tabla `inconsistencias_fk`.
   
   CREATE EVENT IF NOT EXISTS validar_foreign_keys
   ON SCHEDULE EVERY 1 WEEK
   DO
   INSERT INTO inconsistencias_fk (tipo, referencia)
   SELECT 'rates', CONCAT('company_id inválido: ', company_id)
   FROM rates
   WHERE company_id NOT IN (SELECT id FROM companies);
   
   ------
   
   ## 🔹 **11. Eliminar calificaciones inválidas antiguas**
   
   > **Historia:** Como técnico, quiero un evento que elimine calificaciones con errores antiguos.
   
   🧠 **Explicación:**
    Borra `rates` donde el valor de `rating` es NULL o <0 y que hayan sido creadas hace más de 3 meses.
   
   🛠️ `DELETE FROM rates WHERE rating IS NULL AND created_at < NOW() - INTERVAL 3 MONTH`
   
   CREATE EVENT IF NOT EXISTS eliminar_calificaciones_invalidas
   ON SCHEDULE EVERY 1 MONTH
   DO
   DELETE FROM rates
   WHERE (rating IS NULL OR rating < 0)
     AND daterating < NOW() - INTERVAL 3 MONTH;
   
   ------
   
   ## 🔹 **12. Cambiar estado de encuestas inactivas automáticamente**
   
   > **Historia:** Como desarrollador, deseo un evento que actualice encuestas que no se han usado en mucho tiempo.
   
   🧠 **Explicación:**
    Cambia el campo `status = 'inactiva'` si una encuesta no tiene nuevas respuestas en más de 6 meses.
   
   CREATE EVENT IF NOT EXISTS desactivar_encuestas_inactivas
   ON SCHEDULE EVERY 1 MONTH
   DO
   UPDATE polls
   SET isactive = FALSE
   WHERE id NOT IN (
     SELECT DISTINCT poll_id
     FROM rates
     WHERE daterating >= NOW() - INTERVAL 6 MONTH
   );
   
   ------
   
   ## 🔹 **13. Registrar auditorías de forma periódica**
   
   > **Historia:** Como administrador, quiero un evento que inserte datos de auditoría periódicamente.
   
   🧠 **Explicación:**
    Cada día, se puede registrar el conteo de productos, usuarios, etc. en una tabla tipo `auditorias_diarias`.
   
   CREATE EVENT IF NOT EXISTS auditoria_diaria
   ON SCHEDULE EVERY 1 DAY
   DO
   INSERT INTO auditorias_diarias (fecha, total_productos, total_clientes)
   SELECT NOW(), 
          (SELECT COUNT(*) FROM products), 
          (SELECT COUNT(*) FROM customers);
   
   ------
   
   ## 🔹 **14. Notificar métricas de calidad a empresas**
   
   > **Historia:** Como gestor, deseo un evento que notifique a las empresas sus métricas de calidad cada lunes.
   
   🧠 **Explicación:**
    Genera una tabla o archivo con `AVG(rating)` por producto y empresa y se registra en `notificaciones_empresa`.
   
   CREATE EVENT IF NOT EXISTS notificar_metricas_calidad
   ON SCHEDULE EVERY 1 WEEK STARTS CURRENT_DATE + INTERVAL 1 - DAYOFWEEK(CURRENT_DATE) DAY
   DO
   INSERT INTO notificaciones_empresa (company_id, mensaje)
   SELECT company_id, CONCAT('Promedio de calidad actualizado: ', AVG(rating))
   FROM quality_products
   GROUP BY company_id;
   
   ------
   
   ## 🔹 **15. Recordar renovación de membresías**
   
   > **Historia:** Como cliente, quiero un evento que me recuerde renovar la membresía próxima a vencer.
   
   🧠 **Explicación:**
    Busca `membershipperiods` donde `end_date` esté entre hoy y 7 días adelante, e inserta recordatorios.
   
   CREATE EVENT IF NOT EXISTS recordar_renovacion_membresias
   ON SCHEDULE EVERY 1 DAY
   DO
   INSERT INTO recordatorios (customer_id, mensaje)
   SELECT customer_id, 'Tu membresía está por vencer.'
   FROM membershipperiods
   WHERE end_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;
   
   ------
   
   ## 🔹 **16. Reordenar estadísticas generales cada semana**
   
   > **Historia:** Como operador, deseo un evento que reordene estadísticas generales.
   
   🧠 **Explicación:**
    Calcula y actualiza métricas como total de productos activos, clientes registrados, etc., en una tabla `estadisticas`.
   
   CREATE EVENT IF NOT EXISTS actualizar_estadisticas_generales
   ON SCHEDULE EVERY 1 WEEK
   DO
   UPDATE estadisticas
   SET total_productos = (SELECT COUNT(*) FROM products),
       total_clientes = (SELECT COUNT(*) FROM customers);
   
   ------
   
   ## 🔹 **17. Crear resúmenes temporales de uso por categoría**
   
   > **Historia:** Como técnico, quiero un evento que cree resúmenes temporales por categoría.
   
   🧠 **Explicación:**
    Cuenta cuántos productos se han calificado en cada categoría y guarda los resultados para dashboards.
   
   CREATE EVENT IF NOT EXISTS resumen_categoria_calificaciones
   ON SCHEDULE EVERY 1 WEEK
   DO
   INSERT INTO resumen_categoria (category_id, total)
   SELECT p.category_id, COUNT(r.id)
   FROM rates r
   JOIN companies c ON r.company_id = c.id
   JOIN companyproducts cp ON cp.company_id = c.id
   JOIN products p ON cp.product_id = p.id
   GROUP BY p.category_id;
   
   ------
   
   ## 🔹 **18. Actualizar beneficios caducados**
   
   > **Historia:** Como gerente, deseo un evento que desactive beneficios que ya expiraron.
   
   🧠 **Explicación:**
    Revisa si un beneficio tiene una fecha de expiración (campo `expires_at`) y lo marca como inactivo.
   
   CREATE EVENT IF NOT EXISTS desactivar_beneficios_expirados
   ON SCHEDULE EVERY 1 DAY
   DO
   UPDATE benefits
   SET isactive = FALSE
   WHERE expires_at IS NOT NULL AND expires_at < CURDATE();
   
   ------
   
   ## 🔹 **19. Alertar productos sin evaluación anual**
   
   > **Historia:** Como auditor, quiero un evento que genere alertas sobre productos sin evaluación anual.
   
   🧠 **Explicación:**
    Busca productos sin `rate` en los últimos 365 días y genera alertas o registros en `alertas_productos`.
   
   CREATE EVENT IF NOT EXISTS validar_fk_rates_polls
   ON SCHEDULE EVERY 1 WEEK
   DO
   CALL validar_claves_foreign_rates_polls();
   
   ------
   
   ## 🔹 **20. Actualizar precios con índice externo**
   
   > **Historia:** Como administrador, deseo un evento que actualice precios según un índice referenciado.
   
   🧠 **Explicación:**
    Se podría tener una tabla `inflacion_indice` y aplicar ese valor multiplicador a los precios de productos activos.
   
   CREATE EVENT IF NOT EXISTS recalcular_estadisticas_generales
   ON SCHEDULE EVERY 1 MONTH
   DO
   UPDATE estadisticas
   SET total_productos = (SELECT COUNT(*) FROM products),
       total_clientes = (SELECT COUNT(*) FROM customers);
   
   

## 🔹 **7. Historias de Usuario con JOINs**

1. ## 🔹 **1. Ver productos con la empresa que los vende**

   > **Historia:** Como analista, quiero consultar todas las empresas junto con los productos que ofrecen, mostrando el nombre del producto y el precio.

   🧠 **Explicación para dummies:**
    Imagina que tienes dos tablas: una con empresas (`companies`) y otra con productos (`products`). Hay una tabla intermedia llamada `companyproducts` que dice qué empresa vende qué producto y a qué precio.
    Con un `JOIN`, unes estas tablas para ver “Empresa A vende Producto X a $10”.

   🔍 Se usa un `INNER JOIN`.

   SELECT c.name AS company_name, p.name AS product_name, cp.price
   FROM companies c
   JOIN companyproducts cp ON c.id = cp.company_id
   JOIN products p ON cp.product_id = p.id;
   
   ------
   
   ## 🔹 **2. Mostrar productos favoritos con su empresa y categoría**

   > **Historia:** Como cliente, deseo ver mis productos favoritos junto con la categoría y el nombre de la empresa que los ofrece.

   🧠 **Explicación:**
    Tú como cliente guardaste algunos productos en favoritos. Quieres ver no solo el nombre, sino también quién lo vende y a qué categoría pertenece.
   
   🔍 Aquí se usan varios `JOIN` para traer todo en una sola consulta bonita y completa.
   
   SELECT f.customer_id, p.name AS product_name, p.category_id, c.name AS company_name
   FROM favorites f
   JOIN details_favorites df ON f.id = df.favorite_id
   JOIN products p ON df.product_id = p.id
   JOIN companyproducts cp ON p.id = cp.product_id
   JOIN companies c ON cp.company_id = c.id;

   ------

   ## 🔹 **3. Ver empresas aunque no tengan productos**

   > **Historia:** Como supervisor, quiero ver todas las empresas aunque no tengan productos asociados.

   🧠 **Explicación:**
    No todas las empresas suben productos de inmediato. Queremos verlas igualmente.
    Un `LEFT JOIN` te permite mostrar la empresa, aunque no tenga productos en la otra tabla.

   🔍 Se une `companies LEFT JOIN`.

   SELECT f.customer_id, p.name AS product_name, p.category_id, c.name AS company_name
   FROM favorites f
   JOIN details_favorites df ON f.id = df.favorite_id
   JOIN products p ON df.product_id = p.id
   JOIN companyproducts cp ON p.id = cp.product_id
   JOIN companies c ON cp.company_id = c.id;
   
   ------
   
   ## 🔹 **4. Ver productos que fueron calificados (o no)**
   
   > **Historia:** Como técnico, deseo obtener todas las calificaciones de productos incluyendo aquellos productos que aún no han sido calificados.
   
   🧠 **Explicación:**
    Queremos ver todos los productos. Si hay calificación, que la muestre; si no, que aparezca como NULL.
    Esto se hace con un `RIGHT JOIN` desde `rates` hacia `products`.
   
   🔍 Así sabrás qué productos no tienen aún calificaciones.
   
   SELECT c.id, c.name, cp.product_id
   FROM companies c
   LEFT JOIN companyproducts cp ON c.id = cp.company_id;
   
   -- 4. Ver productos que fueron calificados (o no)
   SELECT p.id, p.name, r.rating
   FROM products p
   LEFT JOIN companyproducts cp ON p.id = cp.product_id
   LEFT JOIN rates r ON cp.company_id = r.company_id;
   
   ------
   
   ## 🔹 **5. Ver productos con promedio de calificación y empresa**

   > **Historia:** Como gestor, quiero ver productos con su promedio de calificación y nombre de la empresa.

   🧠 **Explicación:**
    El producto vive en la tabla `products`, el precio y empresa están en `companyproducts`, y las calificaciones en `rates`.
    Un `JOIN` permite unir todo y usar `AVG(rates.valor)` para calcular el promedio.

   🔍 Combinas `products JOIN companyproducts JOIN companies JOIN rates`.

   SELECT p.name AS product_name, c.name AS company_name, AVG(r.rating) AS avg_rating
   FROM products p
   JOIN companyproducts cp ON p.id = cp.product_id
   JOIN companies c ON cp.company_id = c.id
   JOIN rates r ON cp.company_id = r.company_id
   GROUP BY p.id, c.id;
   
   ------
   
   ## 🔹 **6. Ver clientes y sus calificaciones (si las tienen)**
   
   > **Historia:** Como operador, deseo obtener todos los clientes y sus calificaciones si existen.
   
   🧠 **Explicación:**
    A algunos clientes no les gusta calificar, pero igual deben aparecer.
    Se hace un `LEFT JOIN` desde `customers` hacia `rates`.

   🔍 Devuelve calificaciones o `NULL` si el cliente nunca calificó.

   SELECT cu.id, cu.name, r.rating
   FROM customers cu
   LEFT JOIN rates r ON cu.id = r.customer_id;

   ------
   
   ## 🔹 **7. Ver favoritos con la última calificación del cliente**
   
   > **Historia:** Como cliente, quiero consultar todos mis favoritos junto con la última calificación que he dado.
   
   🧠 **Explicación:**
    Esto requiere unir tus productos favoritos (`favorites` + `details_favorites`) con las calificaciones (`rates`), filtradas por la fecha más reciente.

   🔍 Requiere `JOIN` y subconsulta con `MAX(created_at)` o `ORDER BY` + `LIMIT 1`.
   
   SELECT f.customer_id, df.product_id, MAX(r.daterating) AS ultima_fecha, r.rating
   FROM favorites f
   JOIN details_favorites df ON f.id = df.favorite_id
   JOIN companyproducts cp ON df.product_id = cp.product_id
   LEFT JOIN rates r ON cp.company_id = r.company_id AND r.customer_id = f.customer_id
   GROUP BY f.customer_id, df.product_id;
   
   ------
   
   ## 🔹 **8. Ver beneficios incluidos en cada plan de membresía**

   > **Historia:** Como administrador, quiero unir `membershipbenefits`, `benefits` y `memberships`.

   🧠 **Explicación:**
    Tienes planes (`memberships`), beneficios (`benefits`) y una tabla que los relaciona (`membershipbenefits`).
    Un `JOIN` muestra qué beneficios tiene cada plan.

   SELECT m.name AS membership, b.description AS benefit
   FROM membershipbenefits mb
   JOIN memberships m ON mb.membership_id = m.id
   JOIN benefits b ON mb.benefit_id = b.id;

   ------

   ## 🔹 **9. Ver clientes con membresía activa y sus beneficios**

   > **Historia:** Como gerente, deseo ver todos los clientes con membresía activa y sus beneficios actuales.
   
   🧠 **Explicación:** La intención es **mostrar una lista de clientes** que:

   1. Tienen **una membresía activa** (vigente hoy).
   2. Y a esa membresía le corresponden **uno o más beneficios**.
   
   🔍 Mucho `JOIN`, pero muestra todo lo que un cliente recibe por su membresía.
   
   SELECT cu.id, cu.name, b.description
   FROM customers cu
   JOIN membershipperiods mp ON cu.id = mp.customer_id
   JOIN membershipbenefits mb ON mp.membership_id = mb.membership_id
   JOIN benefits b ON mb.benefit_id = b.id
   WHERE CURDATE() BETWEEN mp.start_date AND mp.end_date;
   
   ------
   
   ## 🔹 **10. Ver ciudades con cantidad de empresas**
   
   > **Historia:** Como operador, quiero obtener todas las ciudades junto con la cantidad de empresas registradas.
   
   🧠 **Explicación:**
    Unes `citiesormunicipalities` con `companies` y cuentas cuántas empresas hay por ciudad (`COUNT(*) GROUP BY ciudad`).
   
   SELECT ci.name AS city, COUNT(c.id) AS total_companies
   FROM citiesormunicipalities ci
   LEFT JOIN companies c ON ci.code = c.city_id
   GROUP BY ci.name;

   ------

   ## 🔹 **11. Ver encuestas con calificaciones**
   
   > **Historia:** Como analista, deseo unir `polls` y `rates`.
   
   🧠 **Explicación:**
    Cada encuesta (`polls`) puede estar relacionada con una calificación (`rates`).
    El `JOIN` permite ver qué encuesta usó el cliente para calificar.
   
   SELECT p.name AS poll_name, r.rating
   FROM polls p
   JOIN rates r ON p.id = r.poll_id;
   
   ------
   
   ## 🔹 **12. Ver productos evaluados con datos del cliente**
   
   > **Historia:** Como técnico, quiero consultar todos los productos evaluados con su fecha y cliente.
   
   🧠 **Explicación:**
    Unes `rates`, `products` y `customers` para saber qué cliente evaluó qué producto y cuándo.
   
   SELECT p.name AS product_name, r.daterating, cu.name AS customer_name
   FROM rates r
   JOIN companyproducts cp ON cp.company_id = r.company_id
   JOIN products p ON cp.product_id = p.id
   JOIN customers cu ON r.customer_id = cu.id;
   
   ------
   
   ## 🔹 **13. Ver productos con audiencia de la empresa**
   
   > **Historia:** Como supervisor, deseo obtener todos los productos con la audiencia objetivo de la empresa.

   🧠 **Explicación:**
    Unes `products`, `companyproducts`, `companies` y `audiences` para saber si ese producto está dirigido a niños, adultos, etc.
   
   SELECT p.name AS product_name, a.description AS audience
   FROM products p
   JOIN companyproducts cp ON p.id = cp.product_id
   JOIN companies c ON cp.company_id = c.id
   JOIN audiences a ON c.audience_id = a.id;
   
   ------
   
   ## 🔹 **14. Ver clientes con sus productos favoritos**
   
   > **Historia:** Como auditor, quiero unir `customers` y `favorites`.
   
   🧠 **Explicación:**
    Para ver qué productos ha marcado como favorito cada cliente.
    Unes `customers` → `favorites` → `details_favorites` → `products`.
   
   SELECT cu.id, cu.name, p.name AS favorite_product
   FROM customers cu
   JOIN favorites f ON cu.id = f.customer_id
   JOIN details_favorites df ON f.id = df.favorite_id
   JOIN products p ON df.product_id = p.id;
   
   ------
   
   ## 🔹 **15. Ver planes, periodos, precios y beneficios**
   
   > **Historia:** Como gestor, deseo obtener la relación de planes de membresía, periodos, precios y beneficios.
   
   🧠 **Explicación:**
    Unes `memberships`, `membershipperiods`, `membershipbenefits`, y `benefits`.
   
   🔍 Sirve para hacer un catálogo completo de lo que incluye cada plan.
   
   SELECT m.name AS membership, mp.start_date, mp.end_date, b.description AS benefit
   FROM memberships m
   JOIN membershipperiods mp ON m.id = mp.membership_id
   JOIN membershipbenefits mb ON m.id = mb.membership_id
   JOIN benefits b ON mb.benefit_id = b.id;
   
   ------
   
   ## 🔹 **16. Ver combinaciones empresa-producto-cliente calificados**
   
   > **Historia:** Como desarrollador, quiero consultar todas las combinaciones empresa-producto-cliente que hayan sido calificadas.
   
   🧠 **Explicación:**
    Une `rates` con `products`, `companyproducts`, `companies`, y `customers`.
   
   🔍 Así sabes: quién calificó, qué producto, de qué empresa.
   
   SELECT c.name AS company_name, p.name AS product_name, cu.name AS customer_name, r.rating
   FROM rates r
   JOIN companies c ON r.company_id = c.id
   JOIN companyproducts cp ON cp.company_id = c.id
   JOIN products p ON cp.product_id = p.id
   JOIN customers cu ON r.customer_id = cu.id;
   
   ------
   
   ## 🔹 **17. Comparar favoritos con productos calificados**
   
   > **Historia:** Como cliente, quiero ver productos que he calificado y también tengo en favoritos.
   
   🧠 **Explicación:**
    Une `details_favorites` y `rates` por `product_id`, filtrando por tu `customer_id`.
   
   SELECT DISTINCT df.product_id
   FROM details_favorites df
   JOIN companyproducts cp ON df.product_id = cp.product_id
   JOIN rates r ON cp.company_id = r.company_id
   JOIN favorites f ON df.favorite_id = f.id
   WHERE r.customer_id = f.customer_id;
   
   ------
   
   ## 🔹 **18. Ver productos ordenados por categoría**
   
   > **Historia:** Como operador, quiero unir `categories` y `products`.
   
   🧠 **Explicación:**
    Cada producto tiene una categoría.
    El `JOIN` permite ver el nombre de la categoría junto al nombre del producto.
   
   SELECT c.name AS category, p.name AS product_name
   FROM categories c
   JOIN products p ON p.category_id = c.id;
   
   ------
   
   ## 🔹 **19. Ver beneficios por audiencia, incluso vacíos**
   
   > **Historia:** Como especialista, quiero listar beneficios por audiencia, incluso si no tienen asignados.
   
   🧠 **Explicación:**
    Un `LEFT JOIN` desde `audiences` hacia `audiencebenefits` y luego `benefits`.
   
   🔍 Audiencias sin beneficios mostrarán `NULL`.
   
   SELECT a.name AS audience, b.description AS benefit
   FROM audiences a
   LEFT JOIN audiencebenefits ab ON a.id = ab.audience_id
   LEFT JOIN benefits b ON ab.benefit_id = b.id;
   
   ------
   
   ## 🔹 **20. Ver datos cruzados entre calificaciones, encuestas, productos y clientes**
   
   > **Historia:** Como auditor, deseo una consulta que relacione `rates`, `polls`, `products` y `customers`.
   
   🧠 **Explicación:**
    Es una auditoría cruzada. Se une todo lo relacionado con una calificación:
   
   - ¿Quién calificó? (`customers`)
   
   - ¿Qué calificó? (`products`)
   
   - ¿En qué encuesta? (`polls`)
   
   - ¿Qué valor dio? (`rates`)
   
     SELECT cu.name AS customer, p.name AS product, poll.name AS encuesta, r.rating
     FROM rates r
     JOIN polls poll ON r.poll_id = poll.id
     JOIN companies c ON r.company_id = c.id
     JOIN companyproducts cp ON cp.company_id = c.id
     JOIN products p ON cp.product_id = p.id
     JOIN customers cu ON r.customer_id = cu.id;

## 🔹 **8. Historias de Usuario con Funciones Definidas por el Usuario (UDF)**

1. Como analista, quiero una función que calcule el **promedio ponderado de calidad** de un producto basado en sus calificaciones y fecha de evaluación.

   > **Explicación:** Se desea una función `calcular_promedio_ponderado(product_id)` que combine el valor de `rate` y la antigüedad de cada calificación para dar más peso a calificaciones recientes.
   >
   > DELIMITER $$
   > CREATE FUNCTION calcular_promedio_ponderado(p_product_id INT)
   > RETURNS DECIMAL(5,2)
   > BEGIN
   >   DECLARE resultado DECIMAL(5,2);
   >   SELECT AVG(r.rating * (DATEDIFF(NOW(), r.daterating) + 1)) / AVG(DATEDIFF(NOW(), r.daterating) + 1)
   >   INTO resultado
   >   FROM companyproducts cp
   >   JOIN rates r ON cp.company_id = r.company_id
   >   WHERE cp.product_id = p_product_id;
   >   RETURN resultado;
   > END$$
   > DELIMITER ;

2. Como auditor, deseo una función que determine si un producto ha sido **calificado recientemente** (últimos 30 días).

   > **Explicación:** Se busca una función booleana `es_calificacion_reciente(fecha)` que devuelva `TRUE` si la calificación se hizo en los últimos 30 días.
   >
   > DELIMITER $$
   > CREATE FUNCTION es_calificacion_reciente(p_date DATE)
   > RETURNS BOOLEAN
   > BEGIN
   >   RETURN DATEDIFF(NOW(), p_date) <= 30;
   > END$$
   > DELIMITER ;

3. Como desarrollador, quiero una función que reciba un `product_id` y devuelva el **nombre completo de la empresa** que lo vende.

   > **Explicación:** La función `obtener_empresa_producto(product_id)` haría un `JOIN` entre `companyproducts` y `companies` y devolvería el nombre de la empresa.
   >
   > DELIMITER $$
   > CREATE FUNCTION obtener_empresa_producto(p_product_id INT)
   > RETURNS VARCHAR(80)
   > BEGIN
   >   DECLARE resultado VARCHAR(80);
   >   SELECT c.name INTO resultado
   >   FROM companies c
   >   JOIN companyproducts cp ON c.id = cp.company_id
   >   WHERE cp.product_id = p_product_id
   >   LIMIT 1;
   >   RETURN resultado;
   > END$$
   > DELIMITER ;

4. Como operador, deseo una función que, dado un `customer_id`, me indique si el cliente tiene una **membresía activa**.

   > **Explicación:** `tiene_membresia_activa(customer_id)` consultaría la tabla `membershipperiods` para ese cliente y verificaría si la fecha actual está dentro del rango.
   >
   > DELIMITER $$
   > CREATE FUNCTION tiene_membresia_activa(p_customer_id INT)
   > RETURNS BOOLEAN
   > BEGIN
   >   RETURN EXISTS (
   >     SELECT 1 FROM membershipperiods
   >     WHERE customer_id = p_customer_id AND CURDATE() BETWEEN start_date AND end_date
   >   );
   > END$$
   > DELIMITER ;

5. Como administrador, quiero una función que valide si una ciudad tiene **más de X empresas registradas**, recibiendo la ciudad y el número como 

   parámetros.

   > **Explicación:** `ciudad_supera_empresas(city_id, limite)` devolvería `TRUE` si el conteo de empresas en esa ciudad excede `limite`.
   >
   > DELIMITER $$
   > CREATE FUNCTION ciudad_supera_empresas(p_city_id VARCHAR(6), p_limite INT)
   > RETURNS BOOLEAN
   > BEGIN
   >   DECLARE total INT;
   >   SELECT COUNT(*) INTO total FROM companies WHERE city_id = p_city_id;
   >   RETURN total > p_limite;
   > END$$
   > DELIMITER ;

6. Como gerente, deseo una función que, dado un `rate_id`, me devuelva una **descripción textual de la calificación** (por ejemplo, “Muy bueno”, “Regular”).

   > **Explicación:** `descripcion_calificacion(valor)` devolvería “Excelente” si `valor = 5`, “Bueno” si `valor = 4`, etc.
   >
   > DELIMITER $$
   > CREATE FUNCTION descripcion_calificacion(p_rating INT)
   > RETURNS VARCHAR(20)
   > BEGIN
   >   RETURN CASE
   >     WHEN p_rating >= 5 THEN 'Excelente'
   >     WHEN p_rating >= 4 THEN 'Bueno'
   >     WHEN p_rating >= 3 THEN 'Regular'
   >     ELSE 'Malo'
   >   END;
   > END$$
   > DELIMITER ;

7. Como técnico, quiero una función que devuelva el **estado de un producto** en función de su evaluación (ej. “Aceptable”, “Crítico”).

   > **Explicación:** `estado_producto(product_id)` clasificaría un producto como “Crítico”, “Aceptable” o “Óptimo” según su promedio de calificaciones.
   >
   > DELIMITER $$
   > CREATE FUNCTION estado_producto(p_product_id INT)
   > RETURNS VARCHAR(20)
   > BEGIN
   >   DECLARE avg_rating DECIMAL(5,2);
   >   SELECT AVG(r.rating) INTO avg_rating
   >   FROM companyproducts cp
   >   JOIN rates r ON cp.company_id = r.company_id
   >   WHERE cp.product_id = p_product_id;
   >
   >   RETURN CASE
   >     WHEN avg_rating >= 4 THEN 'Óptimo'
   >     WHEN avg_rating >= 2 THEN 'Aceptable'
   >     ELSE 'Crítico'
   >   END;
   > END$$
   > DELIMITER ;

8. Como cliente, deseo una función que indique si un producto está **entre mis favoritos**, recibiendo el `product_id` y mi `customer_id`.

   > **Explicación:** `es_favorito(customer_id, product_id)` devolvería `TRUE` si hay un registro en `details_favorites`.
   >
   > DELIMITER $$
   > CREATE FUNCTION es_favorito(p_customer_id INT, p_product_id INT)
   > RETURNS BOOLEAN
   > BEGIN
   >   RETURN EXISTS (
   >     SELECT 1 FROM favorites f
   >     JOIN details_favorites df ON f.id = df.favorite_id
   >     WHERE f.customer_id = p_customer_id AND df.product_id = p_product_id
   >   );
   > END$$
   > DELIMITER ;

9. Como gestor de beneficios, quiero una función que determine si un beneficio está **asignado a una audiencia específica**, retornando verdadero o falso.

   > **Explicación:** `beneficio_asignado_audiencia(benefit_id, audience_id)` buscaría en `audiencebenefits` y retornaría `TRUE` si hay coincidencia.
   >
   > DELIMITER $$
   > CREATE FUNCTION beneficio_asignado_audiencia(p_benefit_id INT, p_audience_id INT)
   > RETURNS BOOLEAN
   > BEGIN
   >   RETURN EXISTS (
   >     SELECT 1 FROM audiencebenefits
   >     WHERE benefit_id = p_benefit_id AND audience_id = p_audience_id
   >   );
   > END$$
   > DELIMITER ;

10. Como auditor, deseo una función que reciba una fecha y determine si se encuentra dentro de un **rango de membresía activa**.

    > **Explicación:** `fecha_en_membresia(fecha, customer_id)` compararía `fecha` con los rangos de `membershipperiods` activos del cliente.
    >
    > DELIMITER $$
    > CREATE FUNCTION fecha_en_membresia(p_fecha DATE, p_customer_id INT)
    > RETURNS BOOLEAN
    > BEGIN
    >   RETURN EXISTS (
    >     SELECT 1 FROM membershipperiods
    >     WHERE customer_id = p_customer_id AND p_fecha BETWEEN start_date AND end_date
    >   );
    > END$$
    > DELIMITER ;

11. Como desarrollador, quiero una función que calcule el **porcentaje de calificaciones positivas** de un producto respecto al total.

    > **Explicación:** `porcentaje_positivas(product_id)` devolvería la relación entre calificaciones mayores o iguales a 4 y el total de calificaciones.
    >
    > DELIMITER $$
    > CREATE FUNCTION porcentaje_positivas(p_product_id INT)
    > RETURNS DECIMAL(5,2)
    > BEGIN
    >   DECLARE total INT DEFAULT 0;
    >   DECLARE positivas INT DEFAULT 0;
    >
    >   SELECT COUNT(*) INTO total
    >   FROM companyproducts cp
    >   JOIN rates r ON cp.company_id = r.company_id
    >   WHERE cp.product_id = p_product_id;
    >
    >   SELECT COUNT(*) INTO positivas
    >   FROM companyproducts cp
    >   JOIN rates r ON cp.company_id = r.company_id
    >   WHERE cp.product_id = p_product_id AND r.rating >= 4;
    >
    >   RETURN IF(total > 0, positivas * 100.0 / total, 0);
    > END$$
    > DELIMITER ;

12. Como supervisor, deseo una función que calcule la **edad de una calificación**, en días, desde la fecha actual.

    > Un **supervisor** quiere saber cuántos **días han pasado** desde que se registró una calificación de un producto. Este cálculo debe hacerse dinámicamente comparando la **fecha actual del sistema (`CURRENT_DATE`)** con la **fecha en que se hizo la calificación** (que suponemos está almacenada en un campo como `created_at` o `rate_date` en la tabla `rates`).
    >
    > DELIMITER $$
    > CREATE FUNCTION edad_calificacion(p_rate_date DATE)
    > RETURNS INT
    > BEGIN
    >   RETURN DATEDIFF(NOW(), p_rate_date);
    > END$$
    > DELIMITER ;

13. Como operador, quiero una función que, dado un `company_id`, devuelva la **cantidad de productos únicos** asociados a esa empresa.

    > **Explicación:** `productos_por_empresa(company_id)` haría un `COUNT(DISTINCT product_id)` en `companyproducts`.
    >
    > DELIMITER $$
    > CREATE FUNCTION productos_por_empresa(p_company_id VARCHAR(20))
    > RETURNS INT
    > BEGIN
    >   DECLARE total INT;
    >   SELECT COUNT(DISTINCT product_id) INTO total FROM companyproducts WHERE company_id = p_company_id;
    >   RETURN total;
    > END$$
    > DELIMITER ;

14. Como gerente, deseo una función que retorne el **nivel de actividad** de un cliente (frecuente, esporádico, inactivo), según su número de calificaciones.

    DELIMITER $$
    CREATE FUNCTION nivel_actividad_cliente(p_customer_id INT)
    RETURNS VARCHAR(20)
    BEGIN
      DECLARE total INT;
      SELECT COUNT(*) INTO total FROM rates WHERE customer_id = p_customer_id;
      RETURN CASE
        WHEN total >= 10 THEN 'Frecuente'
        WHEN total >= 3 THEN 'Esporádico'
        ELSE 'Inactivo'
      END;
    END$$
    DELIMITER ;

15. Como administrador, quiero una función que calcule el **precio promedio ponderado** de un producto, tomando en cuenta su uso en favoritos.

    DELIMITER $$
    CREATE FUNCTION precio_promedio_ponderado(p_product_id INT)
    RETURNS DECIMAL(8,2)
    BEGIN
      DECLARE resultado DECIMAL(8,2);
      SELECT AVG(cp.price) INTO resultado
      FROM companyproducts cp
      WHERE cp.product_id = p_product_id;
      RETURN resultado;
    END$$
    DELIMITER ;

16. Como técnico, deseo una función que me indique si un `benefit_id` está asignado a más de una audiencia o membresía (valor booleano).

    DELIMITER $$
    CREATE FUNCTION beneficio_duplicado(p_benefit_id INT)
    RETURNS BOOLEAN
    BEGIN
      RETURN (
        (SELECT COUNT(DISTINCT audience_id) FROM audiencebenefits WHERE benefit_id = p_benefit_id) +
        (SELECT COUNT(DISTINCT membership_id) FROM membershipbenefits WHERE benefit_id = p_benefit_id)
      ) > 1;
    END$$
    DELIMITER ;

17. Como cliente, quiero una función que, dada mi ciudad, retorne un **índice de variedad** basado en número de empresas y productos.

    DELIMITER $$
    CREATE FUNCTION indice_variedad_ciudad(p_city_id VARCHAR(6))
    RETURNS DECIMAL(5,2)
    BEGIN
      DECLARE empresas INT;
      DECLARE productos INT;
      SELECT COUNT(DISTINCT id) INTO empresas FROM companies WHERE city_id = p_city_id;
      SELECT COUNT(DISTINCT cp.product_id) INTO productos
      FROM companies c JOIN companyproducts cp ON c.id = cp.company_id
      WHERE c.city_id = p_city_id;
      RETURN IF(empresas > 0, productos / empresas, 0);
    END$$
    DELIMITER ;

18. Como gestor de calidad, deseo una función que evalúe si un producto debe ser **desactivado** por tener baja calificación histórica.

    DELIMITER $$
    CREATE FUNCTION desactivar_producto(p_product_id INT)
    RETURNS BOOLEAN
    BEGIN
      DECLARE avg_rating DECIMAL(5,2);
      SELECT AVG(r.rating) INTO avg_rating
      FROM companyproducts cp
      JOIN rates r ON cp.company_id = r.company_id
      WHERE cp.product_id = p_product_id;
      RETURN avg_rating < 2;
    END$$
    DELIMITER ;

19. Como desarrollador, quiero una función que calcule el **índice de popularidad** de un producto (combinando favoritos y ratings).

    DELIMITER $$
    CREATE FUNCTION indice_popularidad(p_product_id INT)
    RETURNS DECIMAL(8,2)
    BEGIN
      DECLARE favoritos INT;
      DECLARE ratings INT;

      SELECT COUNT(*) INTO favoritos FROM details_favorites WHERE product_id = p_product_id;

      SELECT COUNT(*) INTO ratings
      FROM companyproducts cp
      JOIN rates r ON cp.company_id = r.company_id
      WHERE cp.product_id = p_product_id;

      RETURN favoritos + ratings;
    END$$
    DELIMITER ;

20. Como auditor, deseo una función que genere un código único basado en el nombre del producto y su fecha de creación.

    DELIMITER $$
    CREATE FUNCTION codigo_unico_producto(p_name VARCHAR(80), p_date DATE)
    RETURNS VARCHAR(255)
    BEGIN
      RETURN CONCAT(p_name, '_', DATE_FORMAT(p_date, '%Y%m%d'), '_', FLOOR(RAND()*10000));
    END$$
    DELIMITER ;

# Requerimientos de entrega

1. Instrucciones DDL con la creación de la estructura completa de la base de datos.
2. Instrucciones Insert para cada una de las tablas.
3. Documentos de codificacion geografica : https://drive.google.com/drive/folders/1zvAgacAzQUo2zyHho6C7eHhmQkc3SHmO?usp=sharing