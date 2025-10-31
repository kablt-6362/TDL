-- 테이블 설계

CREATE TABLE User(
	id INT PRIMARY KEY AUtO_INCREMENT,
    email VARCHAR(50),
    password INT,
    phone INT,
    user_rank char
);
SELECT*FROM user;

CREATE TABLE Business_user(
	id INt PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    email VARCHAR(50),
    password INT,
    phone INT,
    business_number INT,
    business_name VARCHAR(50)
);


CREATE TABLE store(
	id INT PRIMARY KEY AUTO_INCREMENT,
    b_u_id INT,
    storename VARCHAR(50),
    address VARCHAR(100),
    intro TEXT,
    info TEXT,
    FOREIGN KEY (b_u_id) REFERENCES Business_user(id)
);
-- INSERT INTO store (b_u_id,storename,address,intro,info) VALUES (2,'남도횟집','서울마천동','초밥과 우동으로','호주');
SELECT*FROM store;

CREATE TABLE menu_category(
	id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50),
    store_id int,
    FOREIGN KEY (store_id) REFERENCES store(id)
);
--  INSERT INTO menu_category (category_name,store_id) VALUES ('아이스크림',1);
 
SELECT*FROM menu_category;

CREATE TABLE menu (
	id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    name VARCHAR(50),
    descroption VARCHAR(50),
    img VARCHAR(50),
    stock INT,
    price int,
    FOREIGN KEY (category_id) REFERENCES menu_category(id)
);
-- INSERT INTO menu(category_id,name,descroption,img,stock,price) VALUES(2,'트러플머쉬럼와퍼','버섯향포함','햄버거사진',40,10500);
-- SELECT*FROM menu;

CREATE TABLE orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    store_id INT,
    dates DATE,
    total_price INT,
    order_state VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (store_id) REFERENCES store(id) 
);
-- 테이블 속성 제약조건변경
ALTER TABLE orders
MODIFY COLUMN dates DATE DEFAULT (CURRENT_DATE());
ALTER TABLE orders
MODIFY COLUMN order_state VARCHAR(50) DEFAULT '대기중';

CREATE TABLE order_item(
	id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    menu_id INT,
    quantity INT,
    price INT,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE tABLE payment(
	id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    method VARCHAR(50),
    created_at DATE,
    amount INT,
    state VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);
ALTER TABLE payment
MODIFY COLUMN created_at DATE DEFAULT (CURRENT_DATE());

CREATE TABLE address(
	id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    detail VARCHAR(50),		-- 상세주소 
    alias VARCHAR(50),		-- 별칭(회사,집,모임장소)
    address_load VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE review (
	id INT PRIMARY KEY AUTO_INCREMeNT,
    img VARCHAR(50),
    contexts VARCHAR(100),
    user_id INT,
    store_id INT,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (store_id) REFERENCES store(id)
);

CREATE TABLE review_comment (
	id INT PRIMARY KEY AUTO_INCREMENT,
    bu_id INT,
    review_id INT,
    comment_detail VARCHAR(50),
    FOREIGN KEY (bu_id) REFERENCES business_user(id),
    FOREIGN KEY (review_id) REFERENCES review(id)
);
-- 카테고리정보 
CREATE TABLE store_category(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(50)
);
SELECT*FROM store_category;
-- 가게카테고리 
CREATE TABLE store_connect_category(
	id INt PRIMARY KEY AUTO_INCREMENT,
    store_category_id INT,
    store_id INT,
    FOREIGN KEY (store_category_id) REFERENCES store_category(id),
    FOREIGN KEY (store_id) REFERENCES store(id)
);
SELECT*FROM store_connect_category;
