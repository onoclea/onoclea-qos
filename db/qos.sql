create table nodes(
	id integer primary key autoincrement not null,
	name text not null unique,
	comment text
);

create table cidrs(
	id integer primary key autoincrement not null,
	cidr text not null unique,
	node_id integer not null,
	foreign key(node_id) references nodes(id)
);

create table limits(
	id integer primary key autoincrement not null,
	rate text not null,
	ceil text not null,
	node_id integer not null,
	foreign key(node_id) references nodes(node_id)
);

insert into nodes(id, name, comment) values (0, 'all', 'aggregated traffic');
insert into cidrs(id, cidr, node_id) values (0, '0.0.0.0/0', 0);
insert into limits(id, rate, ceil, node_id) values (0, 'unlimited', 'unlimited', 0);
