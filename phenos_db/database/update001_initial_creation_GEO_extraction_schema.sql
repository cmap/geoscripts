drop table if exists gsm_signature;
drop table if exists class;
drop table if exists signature_gse;
drop table if exists signature;
drop table if exists pert_id_type;
drop table if exists pert_type;
drop table if exists local_perturbagen;
drop table if exists batch_signature;
drop table if exists batch;

create table pert_type (
	id 		integer primary key,
	name		text not null unique,
	description	text
);

create table pert_id_type (  --e.g. entrez_id, mesh, local, uniprot, PubChem CID, BRD
	id		integer primary key,
	name		text not null unique,
	description	text
);

create table local_perturbagen(
	id			integer primary key,
	pert_mfc_desc		text not null
);

create table signature (
	id			integer primary key,
	formal_sig_id		text not null unique,
	pert_type_id		integer not null,
	pert_mfc_desc		text,
	pert_id_type_id		text not null,
	pert_id			text not null,
	pheno_label		text not null,

	foreign key(pert_type_id) references pert_type(id),
	foreign key(pert_id_type_id) references pert_id_type(id)
);

create table signature_gse (
	id			integer primary key,
	signature_id		integer not null,
	gse			text not null,

	foreign key(signature_id) references signature(id)
);

create table class (
	id			integer primary key,
	name			text not null unique,
	description		text
);

create table gsm_signature (
	id			integer primary key,
	gsm			text not null,
	signature_id		integer not null,
	gpl			text not null,
	class_id		integer,
	description		text,

	foreign key(signature_id) references signature(id),
	foreign key(class_id) references class(id),
	unique(gsm, signature_id)
);

create table batch (
	id			integer primary key,
	name			text,
	last_attempt_date	date
);

create table batch_signature(
	id			integer primary key,
	batch_id		integer not null,
	signature_id		integer not null,

	foreign key (batch_id) references batch(id),
	foreign key (signature_id) references signature(id)
);
