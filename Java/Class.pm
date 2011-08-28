package Java::Class;

use Moose;

use Carp;

use Java::Class::Version;
use Java::Class::ConstantPool;
use Java::Class::Interfaces;
use Java::Class::Fields;
use Java::Class::Methods;

extends 'Java::Class::Element';

my $MAGIC_NUMBER = 0xCAFEBABE;

our %ACCESS_FLAGS = (
	PUBLIC		=> 0x0001,
	FINAL		=> 0x0010,
	SUPER		=> 0x0020,
	INTERFACE	=> 0x0200,
	ABSTRACT	=> 0x0400
);

has 'version' => (
	is			=> 'ro',
	isa			=> 'Java::Class::Version',
	writer		=> '_version'
);

has 'constant_pool' => (
	is			=> 'ro',
	isa			=> 'Java::Class::ConstantPool',
	writer		=> '_constant_pool'
);

has 'access_flags' => (
	is			=> 'ro',
	isa			=> 'Num',
	writer		=> '_access_flags'
);

has 'this_class' => (
	is			=> 'ro',
	isa			=> 'Num',
	writer		=> '_this_class'
);

has 'super_class' => (
	is			=> 'ro',
	isa			=> 'Num',
	writer		=> '_super_class'
);

has 'interfaces' => (
	is			=> 'ro',
	isa			=> 'Java::Class::Interfaces',
	writer		=> '_interfaces'
);

has 'fields' => (
	is			=> 'ro',
	isa			=> 'Java::Class::Fields',
	writer		=> '_fields'
);

has 'methods' => (
	is			=> 'ro',
	isa			=> 'Java::Class::Methods',
	writer		=> '_methods'
);

has 'attributes' => (
	is			=> 'ro',
	isa			=> 'Java::Class::Attributes',
	writer		=> '_attributes'
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	my $magic = $reader->read_u4;
	$magic == $MAGIC_NUMBER or croak sprintf 'invalid magic number: 0x%X', $magic;
	
	$self->_version( Java::Class::Version->new( reader => $reader ) );
	$self->_constant_pool( Java::Class::ConstantPool->new( reader => $reader ) );
	$self->_access_flags( $reader->read_u2 );
	$self->_this_class( $reader->read_u2 );
	$self->_super_class( $reader->read_u2 );
	$self->_interfaces( Java::Class::Interfaces->new( reader => $reader ) );
	$self->_fields( Java::Class::Fields->new( reader => $reader, constant_pool => $self->constant_pool ) );
	$self->_methods( Java::Class::Methods->new( reader => $reader, constant_pool => $self->constant_pool ) );
	$self->_attributes( Java::Class::Attributes->new( reader => $reader, constant_pool => $self->constant_pool ) );
}

sub get_method {
	my $self = shift;
	my $name_and_type = shift;
	for my $method ( @{$self->methods->methods} ) {
		return $method if $method->name eq $name_and_type->[0] && $method->descriptor eq $name_and_type->[1];
	}
	undef;
}

sub get_field {
	my $self = shift;
	my $name_and_type = shift;
	for my $field ( @{$self->fields->fields} ) {
		return $field if $field->name eq $name_and_type->[0] && $field->descriptor eq $name_and_type->[1];
	}
	undef;
}

# the internal name of the class, e.g. java/util/String
sub get_name {
	my $self = shift;
	$self->constant_pool->get_class_name( $self->this_class );
}

sub get_super_class_name {
	my $self = shift;
	if( $self->super_class ) {
		$self->constant_pool->get_class_name( $self->super_class );
	} else {
		undef;
	}
}

sub get_instance_fields {
	my $self = shift;
	grep { ! $_->is_static } @{$self->fields->fields};
}

sub get_static_fields {
	my $self = shift;
	grep { $_->is_static } @{$self->fields->fields};
}

sub is_public		{ my $self = shift; $self->_check_acc_flag( 'PUBLIC' ) }
sub is_final		{ my $self = shift; $self->_check_acc_flag( 'FINAL' ) }
sub is_super		{ my $self = shift; $self->_check_acc_flag( 'SUPER' ) }
sub is_interface	{ my $self = shift; $self->_check_acc_flag( 'INTERFACE' ) }
sub is_abstract		{ my $self = shift; $self->_check_acc_flag( 'ABSTRACT' ) }

sub _check_acc_flag {
	my $self = shift;
	my $flag_name = shift;
	
	$self->access_flags & $ACCESS_FLAGS{$flag_name};
}

no Moose;

__PACKAGE__->meta->make_immutable;
