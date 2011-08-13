package Java::Class::Attributes;

use Moose;

use feature 'switch';

use Java::Class::Attributes::Attribute::ConstantValue;
use Java::Class::Attributes::Attribute::Code;
use Java::Class::Attributes::Attribute::Exceptions;

extends 'Java::Class::ElementWithCp';

has 'count' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_count'
);

has 'attributes' => (
	is		=> 'ro',
	isa		=> 'ArrayRef[Java::Class::Attributes::Attribute]',
	default => sub { [] }
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	my $cp = $self->constant_pool;
	
	$self->_count( $reader->read_u2 );
	for(1..$self->count) {
		my $attribute_name_index = $reader->read_u2;
		my $attribute_length = $reader->read_u4;
		my $attribute_type = $cp->get_utf8_info( $attribute_name_index )->string;
		
		my $new_attribute;
		given( $attribute_type ) {
			when( 'ConstantValue' ) {
				$new_attribute = Java::Class::Attributes::Attribute::ConstantValue->new(
						name_index => $attribute_name_index, length => $attribute_length,
						reader => $reader, constant_pool => $cp
				);
			}
			when( 'Code' ) {
				$new_attribute = Java::Class::Attributes::Attribute::Code->new(
						name_index => $attribute_name_index, length => $attribute_length,
						reader => $reader, constant_pool => $cp
				);
			}
			when( 'Exceptions' ) {
				$new_attribute = Java::Class::Attributes::Attribute::Exceptions->new(
						name_index => $attribute_name_index, length => $attribute_length,
						reader => $reader, constant_pool => $cp
				);
			}
#			when( 'LineNumberTable' ) {
#				$new_attribute = Java::Class::Attributes::Attribute::Code->new(
#						reader => $reader
#				);
#			}
			default {
				print 'unknown attribute_type: ' . $attribute_type . "\n";
				$reader->read_bytes( $attribute_length )
			}
		}
		
		push @{$self->attributes}, $new_attribute;
	}
}

1;
