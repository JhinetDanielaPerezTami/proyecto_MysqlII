-- Tabla: countries 
CREATE TABLE countries (
  isocode VARCHAR(6) PRIMARY KEY,
  name VARCHAR(50) UNIQUE,
  alfaisotwo VARCHAR(2) UNIQUE,
  alfaisothree VARCHAR(4) UNIQUE
);

-- Tabla: subdivisioncategories
CREATE TABLE subdivisioncategories (
  id INT PRIMARY KEY,
  description VARCHAR(40)
);

-- Tabla: stateregions 
CREATE TABLE stateregions (
  code VARCHAR(6) PRIMARY KEY,
  name VARCHAR(60),
  countryisocode VARCHAR(6),
  subdivision_id INT,
  FOREIGN KEY (countryisocode) REFERENCES countries(isocode),
  FOREIGN KEY (subdivision_id) REFERENCES subdivisioncategories(id)
);

-- Tabla: citiesormunicipalities
CREATE TABLE citiesormunicipalities (
  code VARCHAR(6) PRIMARY KEY,
  name VARCHAR(60) UNIQUE,
  statereg_id VARCHAR(6),
  FOREIGN KEY (statereg_id) REFERENCES stateregions(code)
);

-- Tabla: phonecodes 
CREATE TABLE phonecodes (
  id INT PRIMARY KEY,
  country_code VARCHAR(5),
  area_code VARCHAR(5),
  city_id VARCHAR(6),
  description VARCHAR(80),
  FOREIGN KEY (city_id) REFERENCES citiesormunicipalities(code)
);

-- Tabla: typesofidentifications
CREATE TABLE typesofidentifications (
  id INT PRIMARY KEY,
  description VARCHAR(60),
  sufix VARCHAR(5)
);

-- Tabla: audiences
CREATE TABLE audiences (
  id INT PRIMARY KEY,
  description VARCHAR(60)
);

-- Tabla: customers
CREATE TABLE customers (
  id INT PRIMARY KEY,
  name VARCHAR(60),
  city_id VARCHAR(6),
  audience_id INT,
  cellphone VARCHAR(20),
  email VARCHAR(100),
  address VARCHAR(120),
  FOREIGN KEY (city_id) REFERENCES citiesormunicipalities(code),
  FOREIGN KEY (audience_id) REFERENCES audiences(id)
);

-- Tabla: categories
CREATE TABLE categories (
  id INT PRIMARY KEY,
  description VARCHAR(60)
);

-- Tabla: categories_polls
CREATE TABLE categories_polls (
  id INT PRIMARY KEY,
  name VARCHAR(80)
);

-- Tabla: companies 
CREATE TABLE companies (
  id VARCHAR(20) PRIMARY KEY,
  type_id INT,
  name VARCHAR(80),
  category_id INT,
  city_id VARCHAR(6),
  audience_id INT,
  cellphone VARCHAR(15),
  email VARCHAR(80),
  FOREIGN KEY (type_id) REFERENCES typesofidentifications(id),
  FOREIGN KEY (category_id) REFERENCES categories(id),
  FOREIGN KEY (city_id) REFERENCES citiesormunicipalities(code),
  FOREIGN KEY (audience_id) REFERENCES audiences(id)
);

-- Tabla: unitofmeasure
CREATE TABLE unitofmeasure (
  id INT PRIMARY KEY,
  description VARCHAR(60)
);

-- Tabla: products
CREATE TABLE products (
  id INT PRIMARY KEY,
  name VARCHAR(60),
  detail TEXT,
  price DECIMAL(10,2),
  category_id INT,
  image VARCHAR(80),
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Tabla: companyproducts 
CREATE TABLE companyproducts (
  company_id VARCHAR(20),
  product_id INT,
  price DECIMAL(10,2),
  unitmeasure_id INT,
  PRIMARY KEY (company_id, product_id),
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (unitmeasure_id) REFERENCES unitofmeasure(id)
);

-- Tabla: favorites
CREATE TABLE favorites (
  id INT PRIMARY KEY,
  customer_id INT,
  company_id VARCHAR(20),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (company_id) REFERENCES companies(id)
);

-- Tabla: details_favorites 
CREATE TABLE details_favorites (
  favorite_id INT,
  product_id INT,
  category_id INT,
  PRIMARY KEY (favorite_id, product_id),
  FOREIGN KEY (favorite_id) REFERENCES favorites(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Tabla: polls 
CREATE TABLE polls (
  id INT PRIMARY KEY,
  name VARCHAR(80),
  description TEXT,
  isactive BOOLEAN DEFAULT TRUE,
  categorypoll_id INT,
  FOREIGN KEY (categorypoll_id) REFERENCES categories_polls(id)
);

-- Tabla: rates 
CREATE TABLE rates (
  customer_id INT,
  company_id VARCHAR(20),
  poll_id INT,
  daterating DATETIME,
  rating DECIMAL(3,2),
  PRIMARY KEY (customer_id, company_id, poll_id),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (poll_id) REFERENCES polls(id)
);

-- Tabla: quality_products 
CREATE TABLE quality_products (
  product_id INT,
  customer_id INT,
  poll_id INT,
  company_id VARCHAR(20),
  daterating DATETIME,
  rating DECIMAL(3,2),
  PRIMARY KEY (product_id, customer_id, poll_id, company_id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (poll_id) REFERENCES polls(id),
  FOREIGN KEY (company_id) REFERENCES companies(id)
);

-- Tabla: memberships
CREATE TABLE memberships (
  id INT PRIMARY KEY,
  name VARCHAR(50),
  description TEXT
);

-- Tabla: periods
CREATE TABLE periods (
  id INT PRIMARY KEY,
  name VARCHAR(50)
);

-- Tabla: membershipperiods
CREATE TABLE membershipperiods (
  membership_id INT,
  period_id INT,
  price DECIMAL(10,2),
  PRIMARY KEY (membership_id, period_id),
  FOREIGN KEY (membership_id) REFERENCES memberships(id),
  FOREIGN KEY (period_id) REFERENCES periods(id)
);

-- Tabla: benefits
CREATE TABLE benefits (
  id INT PRIMARY KEY,
  description VARCHAR(80),
  detail TEXT
);

-- Tabla: membershipbenefits
CREATE TABLE membershipbenefits (
  membership_id INT,
  period_id INT,
  audience_id INT,
  benefit_id INT,
  PRIMARY KEY (membership_id, period_id, audience_id, benefit_id),
  FOREIGN KEY (membership_id) REFERENCES memberships(id),
  FOREIGN KEY (period_id) REFERENCES periods(id),
  FOREIGN KEY (audience_id) REFERENCES audiences(id),
  FOREIGN KEY (benefit_id) REFERENCES benefits(id)
);

-- Tabla: audiencebenefits
CREATE TABLE audiencebenefits (
  audience_id INT,
  benefit_id INT,
  PRIMARY KEY (audience_id, benefit_id),
  FOREIGN KEY (audience_id) REFERENCES audiences(id),
  FOREIGN KEY (benefit_id) REFERENCES benefits(id)
);