package Java::Class::ConstantPool;

use Moose;
use feature 'switch';
use Carp;

use Java::Class::ConstantPool::Info;
use Java::Class::ConstantPool::Info::Utf8;
use Java::Class::ConstantPool::Info::Integer;
use Java::Class::ConstantPool::Info::Float;
use Java::Class::ConstantPool::Info::Long;
use Java::Class::ConstantPool::Info::Double;
use Java::Class::ConstantPool::Info::Class;
use Java::Class::ConstantPool::Info::String;
use Java::Class::ConstantPool::Info::Fieldref;
use Java::Class::ConstantPool::Info::Methodref;
use Java::Class::ConstantPool::Info::InterfaceMethodref;
use Java::Class::ConstantPool::Info::NameAndType;

extends 'Java::Class::Element';

has 'constant_pool_count' => (
	is		=> 'ro',
	isa		=> 'Int',
	writer	=> '_constant_pool_count'
);

has 'elements' => (
	is		=> 'ro',
	isa		=> 'ArrayRef[Java::Class::ConstantPool::Element]',
	default	=> sub { [] }
);

our %TAGS = (
	1	=> 'Utf8',
	3	=> 'Integer',
	4	=> 'Float',
	5	=> 'Long',
	6	=> 'Double',
	7	=> 'Class',
	8	=> 'String',
	9	=> 'Fieldref',
	10	=> 'Methodref',
	11	=> 'InterfaceMethodref',
	12	=> 'NameAndType',
	# and reverse
	# TODO use some bi-directional map
	'Utf8'					=> 1,
	'Integer'				=> 3,
	'Float'					=> 4,
	'Long'					=> 5,
	'Double'				=> 6,
	'Class'					=> 7,
	'String'				=> 8,
	'Fieldref'				=> 9,
	'Methodref'				=> 10,
	'InterfaceMethodref'	=> 11,
	'NameAndType'			=> 12
);

# high level methods for information about entries -- suitable for external use

sub get_class_name {
	my $self = shift;
	my $index = shift;
	
	my $class_info = $self->get_class_info( $index );
	$self->get_utf8_info( $class_info->name_index )->string;
}

sub get_string {
	my $self = shift;
	my $index = shift;
	
	my $string_info = $self->get_string_info( $index );
	$self->get_utf8_info( $string_info->string_index )->string;
}

sub get_fieldref {
	my $self = shift;
	my $index = shift;
	
	my $fieldref_info = $self->get_fieldref_info( $index );
	$self->_get_ref( $fieldref_info );
}

sub get_methodref {
	my $self = shift;
	my $index = shift;
	
	my $methodref_info = $self->get_methodref_info( $index );
	$self->_get_ref( $methodref_info );
}

sub get_interface_methodref {
	my $self = shift;
	my $index = shift;
	
	my $interface_methodref = $self->get_interface_methodref_info( $index );
	$self->_get_ref( $interface_methodref );
}

sub get_name_and_type {
	my $self = shift;
	my $index = shift;
	
	my $name_and_type_info = $self->get_name_and_type_info( $index );
	[
		$self->get_utf8_info( $name_and_type_info->name_index )->string,
		$self->get_utf8_info( $name_and_type_info->descriptor_index )->string
	]
}

sub _get_ref {
	my $self = shift;
	my $ref_info = shift;
	
	[
		$self->get_class_name( $ref_info->class_index ),
		$self->get_name_and_type( $ref_info->name_and_type_index )
	]
}

# low level methods for info elements -- probably internal use only

sub get_utf8_info {
	my $self = shift;
	my $index = shift;
	
	my $info = $self->elements->[$index - 1];
	$info->tag == $TAGS{Utf8} or confess 'no utf8 entry at index ' . $index;
	
	return $info;
}

sub get_double_info {
	my $self = shift;
	my $index = shift;
	$self->get_validated_info( $index, 'Double' );
}

sub get_float_info {
	my $self = shift;
	my $index = shift;
	$self->get_validated_info( $index, 'Float' );
}

sub get_long_info {
	my $self = shift;
	my $index = shift;
	$self->get_validated_info( $index, 'Long' );
}

sub get_class_info {
	my $self = shift;
	my $index = shift;
	$self->get_validated_info( $index, 'Class' );
}

sub get_string_info {
	my $self = shift;
	my $index = shift;
	$self->get_validated_info( $index, 'String' );
}

sub get_fieldref_info {
	my $self = shift;
	my $index = shift;
	$self->get_validated_info( $index, 'Fieldref' );
}

sub get_methodref_info {
	my $self = shift;
	my $index = shift;
	$self->get_validated_info( $index, 'Methodref' );
}

sub get_interface_methodref_info {
	my $self = shift;
	my $index = shift;
	$self->get_validated_info( $index, 'InterfaceMethodref' );
}

sub get_name_and_type_info {
	my $self = shift;
	my $index = shift;
	$self->get_validated_info( $index, 'NameAndType' );
}

sub get_validated_info {
	my $self = shift;
	my $index = shift;
	my $tag = shift;
	
	$tag = $TAGS{$tag} unless $tag =~ /\d+/; # we want the numerical version
	
	my $entry = $self->get_info( $index );
	$entry->tag == $tag or confess 'requested ', $TAGS{$tag}, ' entry at index ', $index, ' but got ', $TAGS{$entry->tag}, "\n";
	
	$entry;
}

sub get_info {
	my $self = shift;
	my $index = shift;
	
	$self->elements->[$index - 1];
}

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_constant_pool_count( $reader->read_u2 );
	for(my $i=1;$i<$self->constant_pool_count;$i++) {
		my $new_info;
		my $tag = $reader->read_u1;
		given( $tag ) {
			when( 1 ) { $new_info = Java::Class::ConstantPool::Info::Utf8->new( tag => $tag, reader => $reader ) }
			when( 3 ) { $new_info = Java::Class::ConstantPool::Info::Integer->new( tag => $tag, reader => $reader ) }
			when( 4 ) { $new_info = Java::Class::ConstantPool::Info::Float->new( tag => $tag, reader => $reader ) }
			when( 5 ) { $new_info = Java::Class::ConstantPool::Info::Long->new( tag => $tag, reader => $reader ) }
			when( 6 ) { $new_info = Java::Class::ConstantPool::Info::Double->new( tag => $tag, reader => $reader ) }
			when( 7 ) { $new_info = Java::Class::ConstantPool::Info::Class->new( tag => $tag, reader => $reader ) }
			when( 8 ) { $new_info = Java::Class::ConstantPool::Info::String->new( tag => $tag, reader => $reader ) }
			when( 9 ) { $new_info = Java::Class::ConstantPool::Info::Fieldref->new( tag => $tag, reader => $reader ) }
			when( 10) { $new_info = Java::Class::ConstantPool::Info::Methodref->new( tag => $tag, reader => $reader ) }
			when( 11) { $new_info = Java::Class::ConstantPool::Info::InterfaceMethodref->new( tag => $tag, reader => $reader ) }
			when( 12) { $new_info = Java::Class::ConstantPool::Info::NameAndType->new( tag => $tag, reader => $reader ) }
			# if this happens, we're screwed
			default { confess 'unknown tag: ' . $tag }
		}
		$self->elements->[$i-1] = $new_info;
		if( $tag == 5 || $tag == 6 ) { # Long and Double
			# these info elements take up two entries in the constant pool
			$i++;
		}
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
