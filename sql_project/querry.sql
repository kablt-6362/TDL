-- 해당 가게가 무슨 집인지 조회
SELECT
st.id,
st.storename,
stc.name
FROM store st INNER JOIN store_connect_category scc
ON st.id = scc.store_id
INNER JOIN store_category stc
ON stc.id = scc.store_category_id;

-- 가게메뉴 보기 WHERE = (맥도날드,버거킹,남도횟집)
SELECT
store.storename,
me.name,
me.price
FROM menu me INNER JOIN menu_category mc
ON mc.id = me.category_id
INNER JOIN store
ON mc.store_id = store.id
WHERE store.storename='남도횟집';

-- 가게 상세 정보
SELECT
bu.name AS 가게주인,
bu.phone AS 주인전화번호,
bu.business_number AS 사업자번호,
bu.business_name AS 상호명,
st.address AS 가게주소,
st.info AS 원산지
FROM store st INNER JOIN business_user bu
ON st.b_u_id = bu.id;

-- 가게 이름으로 달린 리뷰 조회
SELECT*FROM review rw INNER JOIN store st
ON rw.store_id = st.id
WHERE st.storename='맥도날드';

-- 특정 유저가 쓴 리뷰 찾기
SELECT*FROM review INNER JOIN user
ON review.user_id = user.id
WHERE user.id = 1; 

-- 특정 사용자가 작성한 review 검색(user_id: 1~5)
SELECT*FROM review rv INNER JOIN user us
ON rv.user_id = us.id
WHERE us.id=1;

-- 특정 가게에 달린 리뷰 검색  (버거킹,맥도날드,남도횟집)
SELECT*FROM review re INNER JOIN store st
ON re.store_id = st.id
WHERE st.storename='버거킹'
;

-- 특정 유저한테 달린 리뷰커멘트 검색(user_id: 1~5)
SELECT
rv.user_id AS 리뷰작성자,
rv.contexts AS 리뷰내용,
bu.name AS 사장님,
rc.comment_detail AS 사장답변
FROM review_comment rc INNER JOIN review rv
ON rv.id = rc.review_id
INNER JOIN business_user bu 
ON rc.bu_id = bu.id
WHERE rv.user_id =2
;
-- 특정 사장님이 작성한 코멘트 보기 ('Park','Yark')
SELECT*FROM review_comment rc INNEr JOIN business_user bu
on rc.bu_id = bu.id
WHERE bu.name='Park'
;

-- 주문 과정
--  1번 사용자가 store_id=2 (버거킹)에서 와퍼3개(menu_id=5),롸토르치즈와퍼 4개 (menu_id=6)을 주문한다. 결제내역
--  사용자가 특정 가게에 입장
-- 메뉴 한개 담기시 order 테이블 생성 과 order_item테이블 생성 후 둘다 데티어 추가 
INSERT INTO orders(user_id,store_id)
VALUES (2,3); 

SELECT*FROM orders;
INSERT INTO orders (user_id,store_id) VALUES (4,1);

-- order_items 에 선택한 가게에서 구매할 메뉴와 수량 데이터 삽입.
 INSERT INTO order_item(order_id,menu_id,quantity,price)
 VALUES (4,1,3,(SELECT price FROM menu WHERE id=1));

 SELECT*FROM menu;
 SELECT*FROM order_item;
 
 -- order 테이블에 total_price 업데이트
 -- 1. order_id가 1인 order_item의 quantity * price AS  items 총금액
SELECT SUM(quantity*price)
FROM order_item WHERE order_id =4;
--  2 order 테이블에 price 값 update
UPDATE orders SET total_price=(SELECT SUM(quantity*price)
FROM order_item WHERE order_id =4) WHERE id =4;
SELECT*FROM orders;

-- 결제내역 데이터 입력
SELECT*FROM payment; 
INSERT INTO payment (order_id,method,amount,state)
VALUES (3,'카드결제',(SELECT total_price FROM orders WHERE id=3),'결제완료');

-- 데이터 조회용 쿼리작성 
-- 가게에 대한 정보:누가,어떤이름으로 가게를 만들었나, 가게 메뉴,메뉴가격
SELECT
bus.name,
st.storename,
me.name,
me.price
FROM store st INNER JOIN menu_category mc
ON st.id = mc.store_id 
INNER JOIN menu me
ON me.category_id = mc.id
INNER JOIN business_user bus
ON bus.id = st.b_u_id
WHERE st.id =3;
;

  -- 1. 특정 가게에서 가장 많이 주문한 사용자 찾기
	-- '맥도날드'에서 가장 많은 주문을 한 사용자의 이메일과 총 주문 금액을 찾으세요. 맥도날드에서 주문을 3번이상 했고  3번의 주문금액의 총합
    SELECT
    user.email,
    orders.total_price
    FROM orders INNER JOIN user
    ON orders.user_id = user.id
    WHERE store_id=1;
    
    -- 2. 평균 주문 금액이 30,000원 이상인 가게 찾기
    -- 각 가게별 평균 주문 금액을 계산하고, 그 금액이 30,000원 이상인 가게의 이름과 평균 주문 금액을 찾으세요.
	SELECT AVG(total_price) FROM orders GROUP BY store_id;
    SELECT
    store.storename,
    AVG(total_price)
    FROM orders INNER JOIN store
    ON orders.store_id= store.id
    GROUP BY store_id
    having AVG(total_price) >= 30000;
    -- 3. 지출 금액이 가장 많은 상위 3명의 사용자 순위 매기기
     -- 사용자별 총 지출 금액을 계산하고, 지출 금액이 가장 많은 상위 3명의 사용자를 순위와 함께 보여주세요.
    SELECT
    user_id,
    SUM(total_price) AS 총지출
    FROM orders GROUP BY user_id 
    ORDER BY 총지출 DESC
    LIMIT 3;
    -- 4. 가게별 주문 수 및 등급 분류
    --  모든 가게의 이름과 각 가게의 총 주문 수를 계산하여 보여주세요. 주문이 없는 가게도 결과에 포함되어야 합니다. 또한, 주문 수에 따라 'High'(5개 이상), 'Medium'(2개 이상), 'Low'(2개미만) 등급으로 분류하세요.
    SELECT
    store.storename,
    COUNT(*) AS 주문수,
    CASE 
		WHEN count(*)>=5 THEN 'High'
        WHEN COUNT(*)>=2 THEN 'Midium'
        ELSE 'Low'
    END AS 등급
    FROM orders INNER JOIN store
    ON orders.store_id = store.id
    group by store_id
    ;