create table customers (
    customer_id serial primary key,
    phone varchar,
    name varchar
);

create table services (
    service_id serial primary key,
    name varchar
);

create table appointments (
    appointment_id serial primary key,
    customer_id int,
    service_id int,
    time varchar,
    foreign key (customer_id) references customers(customer_id),
    foreign key (service_id) references services(service_id)
);
