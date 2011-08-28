package Java::Class::Reader;

use Moose;

has 'handle' => (
	is			=> 'ro',
	required	=> 1
);

sub read_u2 {
	my $self = shift;
	return unpack 'n', read_bytes($self, 2);
}

sub read_u4 {
	my $self = shift;
	return unpack 'N', read_bytes($self, 4);
}

sub read_u1 {
	my $self = shift;
	read $self->handle, my $data, 1;
	return unpack 'C', $data;
}

sub read_float {
	my $self = shift;
	return unpack 'f>', read_bytes($self, 4);
}

sub read_double {
	my $self = shift;
	return unpack 'd>', read_bytes($self, 8);
}

sub read_long {
	my $self = shift;
	my $high_bytes = unpack 'N', read_bytes($self, 4);
	my $low_bytes = unpack 'N', read_bytes($self, 4);
	my $value = ($high_bytes << 32) | $low_bytes;
	
	return $value;
}

sub read_bytes {
	my $self = shift;
	my $n = shift;
	
	my $read = 0;
	my $data = '';
	do {
		$read += read $self->handle, my $tmp_data, $n-$read;
		$data .= $tmp_data;
	} while($read < $n);
	
	return $data;
}

no Moose;

__PACKAGE__->meta->make_immutable;
