--drop table item;
create table item
(
	item_id		int			not null,
	item_name	varchar(30)	not null,
	price		decimal(6,2)
)
