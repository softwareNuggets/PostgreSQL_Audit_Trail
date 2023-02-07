--5 steps
--a) create operation_enum
--b) create item_audit trail TABLE
--c) create SEQUENCE
--d) create function to populate audit trail TABLE
--e) create a TRIGGER


--drop type operation_enum
CREATE TYPE operation_enum AS ENUM ('Insert', 'Update', 'Delete');

--drop table item_audit
CREATE TABLE item_audit
(
	item_audit_id		int					not null,
	item_id				int					not null,
	item_name			varchar(30)			not null,
	price				decimal(6,2),
	operation			operation_enum		not null,
	timestamp			timestamp			not null default current_timestamp,
	user_id				varchar(30)			not null
);

--drop sequence item_audit_seq
CREATE SEQUENCE item_audit_seq
START WITH 1
INCREMENT BY 1;

--drop function populate_item_audit
CREATE OR REPLACE FUNCTION populate_item_audit()
RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'UPDATE') THEN
		INSERT INTO item_audit (item_audit_id, item_id, item_name, price, operation, user_id)
		VALUES (nextval('item_audit_seq'), OLD.item_id, OLD.item_name, OLD.price, 'Update', current_user);
	ELSEIF (TG_OP = 'DELETE') THEN
		INSERT INTO item_audit (item_audit_id, item_id, item_name, price, operation, user_id)
		VALUES (nextval('item_audit_seq'), OLD.item_id, OLD.item_name, OLD.price, 'Delete', current_user);
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--drop trigger item_audit_trigger on item
CREATE TRIGGER item_audit_trigger
AFTER UPDATE OR DELETE ON item
FOR EACH ROW
EXECUTE FUNCTION populate_item_audit();



