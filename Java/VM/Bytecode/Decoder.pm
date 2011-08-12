package Java::VM::Bytecode::Decoder;

use Java::VM::Bytecode::Opcode;

use feature qw/ switch /;
use Carp qw/ confess /;

my $code_map = Java::VM::Bytecode::Opcode::get_opcodes();

sub decode {
	my $raw_code = shift;
	
	my @decoded;
	
	my $current_opcode;
	
	my @code_array = unpack 'C*', $raw_code;
	for(my $code_index = 0; $code_index < @code_array; $code_index++) {
		
		my $code = $code_array[$code_index];
		
		my $opcode = $code_map->{$code};
		if($opcode) {
			if($opcode->length == 0) {
				push @decoded, [ $code_index, $code ];
			} else {
				my @args;
				my $length = $opcode->length;
				given($opcode->mnemonic) {
					# these are the instructions with parameters,
					# all other instructions don't have any
					when('aload') {			@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('anewarray') {		@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('astore') {		@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('bipush') {		@args = ( read_1( \@code_array, $code_index+1 ) ) }
					when('checkcast') {		@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('dload') {			@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('dstore') {		@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('fload') {			@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('fstore') {		@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('getfield') {		@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('getstatic') {		@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('goto') {			@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('goto_w') {		die 'goto_w not yet implemented' }
					when('if_acmpeq') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('if_acmpne') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('if_icmpeq') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('if_icmpne') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('if_acmplt') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('if_acmpge') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('if_acmpgt') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('if_acmple') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('ifeq') {			@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('ifne') {			@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('iflt') {			@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('ifge') {			@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('ifgt') {			@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('ifle') {			@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('ifnonnull') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('ifnull') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('iinc') {			@args = ( read_u1( \@code_array, $code_index+1 ), 
													read_1( \@code_array, $code_index+3 ) ) }
					when('iload') {			@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('instanceof') {	@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					# TODO check zero byte at end of invokeinterface
					when('invokeinterface') {	@args = ( read_u2( \@code_array, $code_index+1 ),
														read_u1( \@code_array, $code_index+3 ) ) }
					when('invokespecial') {	@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('invokestatic') {	@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('invokevirtual') {	@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('istore') {		@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('jsr') {			@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('jsr_w') {			die 'jsr_w not yet implemented' }
					when('ldc') {			@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('ldc_w') {			@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('ldc2_w') {		@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('lload') {			@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('lookupswitch') {	@args = read_lookupswitch_args( \@code_array, $code_index+1, \$length ) }
					when('lstore') {		@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('multianewarray') {	@args = ( read_u2( \@code_array, $code_index+1 ),
														read_u1( \@code_array, $code_index+1 ) ) }
					when('new') {			@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('newarray') {		@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('putfield') {		@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('putstatic') {		@args = ( read_u2( \@code_array, $code_index+1 ) ) }
					when('ret') {			@args = ( read_u1( \@code_array, $code_index+1 ) ) }
					when('sipush') {		@args = ( read_2( \@code_array, $code_index+1 ) ) }
					when('tableswitch') {	@args = read_tableswitch_args( \@code_array, $code_index+1, \$length ) }
				}
				push @decoded, [ $code_index, $code, @args ];
				$code_index += $length;
			}
		} else {
			confess "unknown code $code\n";
		}
	}
	
	return \@decoded;
}

sub read_tableswitch_args {
	my ($array, $index, $length_ref) = @_;
	my $pad = (4 - ($index % 4)) % 4;
	$index += $pad;
	
	my $default = read_4($array, $index);
	$index += 4;
	my ($low, $high) = ( read_4($array, $index), read_4($array, $index+4) );
	$index += 8;
	
	my $number_of_offsets = $high - $low + 1;
	my @offsets;
	for(1..$number_of_offsets) {
		push @offsets, read_4($array, $index);
		$index += 4;
	}
	
	$$length_ref = $pad + 24 + $number_of_offsets * 4;
	
	return ( $default, $low, $high, @offsets );
}

sub read_lookupswitch_args {
	my ($array, $index, $length_ref) = @_;
	my $pad = (4 - ($index % 4)) % 4;
	$index += $pad;
	
	my $default = read_4($array, $index);
	$index += 4;
	
	my $npairs = read_4($array, $index);
	$index += 4;
	
	my @pairs;
	for(1..$npairs) {
		push @pairs, [ read_4($array, $index), read_4($array, $index + 4) ];
		$index += 8;
	}
	
	$$length_ref = $pad + 4 + $npairs * 8;
	
	return ( $default, $npairs, @pairs );
}

sub read_u1 {
	my ($array, $index) = @_;
	return $array->[$index];
}

sub read_1 {
	my $v = read_u1 @_;
	if($v > 127) {
		return $v - 256;
	} else {
		return $v;
	}
}

sub read_u2 {
	my ($array, $index) = @_;
	return ($array->[$index] << 8) | $array->[$index+1];
}

sub read_2 {
	my $v = read_u2 @_;
	if($v > 32767) {
		return $v - 65536;
	} else {
		return $v;
	}
}

sub read_u4 {
	my ($array, $index) = @_;
	return ($array->[$index] << 24) | ($array->[$index+1] << 16) | ($array->[$index+2] << 8) | $array->[$index+3];
}

sub read_4 {
	my $v = read_u4 @_;
	if($v > 2_147_483_648) {
		return $v - 4_294_967_296;
	} else {
		return $v;
	}
}

1;
