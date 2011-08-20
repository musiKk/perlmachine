package Java::VM::ClassVariable;

use Moose;

use Java::Class::Fields::Field;
use Java::VM;
use Java::VM::Variable;

extends 'Java::VM::Variable';

has field => (
	is			=> 'ro',
	isa			=> 'Java::Class::Fields::Field',
	required	=> 1
);

has '+name' => (
	required	=> 0,
	lazy		=> 1,
	builder		=> '_build_name'
);

has '+descriptor' => (
	required	=> 0,
	lazy		=> 1,
	builder		=> '_build_descriptor'
);

sub _build_name {
	my $self = shift;
	$self->field->name;
}

sub _build_descriptor {
	my $self = shift;
	$self->field->descriptor;
}

no Moose;

__PACKAGE__->meta->make_immutable;

=pod

=head1 NAME

Java::VM::ClassVariable - An instance of a field, i.e. either a static or
instance variable.

=head1 SYNOPSIS

	my $field = $class->fields->fields->[0];
	Java::VM::ClassVariable->new( field => $field );

=head1 DESCRIPTION

A C<ClassVariable> is a static or instance variable in a class. It reads its
name and descriptor from the provided C<Field>.
