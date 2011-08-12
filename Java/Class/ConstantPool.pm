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
	'Utf8'				=> 1,
	'Integer'			=> 3,
	'Float'				=> 4,
	'Long'				=> 5,
	'Double'			=> 6,
	'Class'				=> 7,
	'String'			=> 8,
	'Fieldref'			=> 9,
	'Methodref'			=> 10,
	'InterfaceMethod'	=> 11,
	'NameAndType'		=> 12
);

# high level methods for information about entries

sub get_class_name {
	my $self = shift;
	my $index = shift;
	
	my $class_info = $self->get_class( $index );
	$self->get_utf8( $class_info->name_index )->string;
}

# low level methods for entries

sub get_utf8 {
	my $self = shift;
	my $index = shift;
	
	my $info = $self->elements->[$index - 1];
	$info->tag == $TAGS{Utf8} or confess 'no utf8 entry at index ' . $index;
	
	return $info;
}

sub get_double {
	my $self = shift;
	my $index = shift;
	$self->get_validated_entry( $index, 'Double' );
}

sub get_class {
	my $self = shift;
	my $index = shift;
	$self->get_validated_entry( $index, 'Class' );
}

sub get_validated_entry {
	my $self = shift;
	my $index = shift;
	my $tag = shift;
	
	$tag = $TAGS{$tag} unless $tag =~ /\d+/; # we want the numerical version
	
	my $entry = $self->get_entry( $index );
	$entry->tag == $tag or confess 'requested ', $TAGS{$tag}, 'entry at index ', $index, ' but got ', $TAGS{$entry->tag}, "\n";
	
	$entry;
}

sub get_entry {
	my $self = shift;
	my $index = shift;
	
	$self->elements->[$index - 1];
}

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_constant_pool_count( $reader->read_u2 );
	for(1..$self->constant_pool_count-1) {
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
			default { die 'unknown tag: ' . $tag }
		}
		push @{$self->elements}, $new_info;
	}
}

1;
