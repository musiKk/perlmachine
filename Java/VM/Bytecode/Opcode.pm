package Java::VM::Bytecode::Opcode;

use Moose;

has 'mnemonic' => (
	is			=> 'ro',
	isa			=> 'Str',
	required	=> 1
);

has 'opcode' => (
	is			=> 'ro',
	isa			=> 'Num',
	required	=> 1
);

has 'length' => (
	is			=> 'ro',
	isa			=> 'Num',
	required	=> 1
);

sub get_opcodes {
	my $opcodes = [];
	
	@{$opcodes} = (
		Java::VM::Bytecode::Opcode->new( mnemonic => 'aaload',		opcode => 0x32,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'aastore',		opcode => 0x53,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'aconst_null',	opcode => 0x01,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'aload',		opcode => 0x19,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'aload_0',		opcode => 0x2a,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'aload_1',		opcode => 0x2b,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'aload_2',		opcode => 0x2c,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'aload_3',		opcode => 0x2d,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'anewarray',	opcode => 0xbd,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'areturn',		opcode => 0xb0,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'arraylength',	opcode => 0xbe,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'astore',		opcode => 0x3a,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'astore_0',	opcode => 0x4b,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'astore_1',	opcode => 0x4c,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'astore_2',	opcode => 0x4d,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'astore_3',	opcode => 0x4e,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'athrow',		opcode => 0xbf,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'baload',		opcode => 0x33,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'bastore',		opcode => 0x54,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'bipush',		opcode => 0x10,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'caload',		opcode => 0x34,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'castore',		opcode => 0x55,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'checkcast',	opcode => 0xc0,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'd2f',			opcode => 0x90,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'd2i',			opcode => 0x8e,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'd2l',			opcode => 0x8f,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dadd',		opcode => 0x63,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'daload',		opcode => 0x31,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dastore',		opcode => 0x52,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dcmpg',		opcode => 0x98,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dcmpl',		opcode => 0x97,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dconst_0',	opcode => 0x0e,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dconst_1',	opcode => 0x0f,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ddiv',		opcode => 0x6f,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dload',		opcode => 0x18,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dload_0',		opcode => 0x26,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dload_1',		opcode => 0x27,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dload_2',		opcode => 0x28,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dload_3',		opcode => 0x29,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dmul',		opcode => 0x6b,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dneg',		opcode => 0x77,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'drem',		opcode => 0x73,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dreturn',		opcode => 0xaf,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dstore',		opcode => 0x39,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dstore_0',	opcode => 0x47,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dstore_1',	opcode => 0x48,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dstore_2',	opcode => 0x49,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dstore_3',	opcode => 0x4a,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dsub',		opcode => 0x67,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dup',			opcode => 0x59,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dup_x1',		opcode => 0x5a,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dup_x2',		opcode => 0x5b,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dup2',		opcode => 0x5c,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dup2_x1',		opcode => 0x5d,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'dup2_x2',		opcode => 0x5e,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'f2d',			opcode => 0x8d,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'f2i',			opcode => 0x8b,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'f2l',			opcode => 0x8c,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fadd',		opcode => 0x62,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'faload',		opcode => 0x30,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fastore',		opcode => 0x51,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fcmpg',		opcode => 0x96,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fcmpl',		opcode => 0x95,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fconst_0',	opcode => 0x0b,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fconst_1',	opcode => 0x0c,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fconst_2',	opcode => 0x0d,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fdiv',		opcode => 0x6e,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fload',		opcode => 0x17,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fload_0',		opcode => 0x22,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fload_1',		opcode => 0x23,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fload_2',		opcode => 0x24,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fload_3',		opcode => 0x25,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fmul',		opcode => 0x6a,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fneg',		opcode => 0x76,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'frem',		opcode => 0x72,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'freturn',		opcode => 0xae,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fstore',		opcode => 0x38,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fstore_0',	opcode => 0x43,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fstore_1',	opcode => 0x44,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fstore_2',	opcode => 0x45,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fstore_3',	opcode => 0x46,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'fsub',		opcode => 0x66,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'getfield',	opcode => 0xb4,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'getstatic',	opcode => 0xb2,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'goto',		opcode => 0xa7,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'goto_w',		opcode => 0xc8,	length => 4 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'i2b',			opcode => 0x91,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'i2c',			opcode => 0x92,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'i2d',			opcode => 0x87,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'i2f',			opcode => 0x86,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'i2l',			opcode => 0x85,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'i2s',			opcode => 0x93,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iadd',		opcode => 0x60,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iaload',		opcode => 0x2e,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iand',		opcode => 0x7e,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iastore',		opcode => 0x4f,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iconst_m1',	opcode => 0x02,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iconst_0',	opcode => 0x03,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iconst_1',	opcode => 0x04,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iconst_2',	opcode => 0x05,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iconst_3',	opcode => 0x06,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iconst_4',	opcode => 0x07,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iconst_5',	opcode => 0x08,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'idiv',		opcode => 0x6c,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'if_acmpeq',	opcode => 0xa5,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'if_acmpne',	opcode => 0xa6,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'if_icmpeq',	opcode => 0x9f,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'if_icmpne',	opcode => 0xa0,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'if_icmplt',	opcode => 0xa1,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'if_icmpge',	opcode => 0xa2,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'if_icmpgt',	opcode => 0xa3,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'if_icmple',	opcode => 0xa4,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ifeq',		opcode => 0x99,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ifne',		opcode => 0x9a,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iflt',		opcode => 0x9b,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ifge',		opcode => 0x9c,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ifgt',		opcode => 0x9d,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ifle',		opcode => 0x9e,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ifnonnull',	opcode => 0xc7,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ifnull',		opcode => 0xc6,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iinc',		opcode => 0x84,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iload',		opcode => 0x15,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iload_0',		opcode => 0x1a,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iload_1',		opcode => 0x1b,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iload_2',		opcode => 0x1c,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iload_3',		opcode => 0x1d,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'imul',		opcode => 0x68,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ineg',		opcode => 0x74,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'instanceof',	opcode => 0xc1,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'invokeinterface',	opcode => 0xb9,	length => 4 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'invokespecial',	opcode => 0xb7,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'invokestatic',	opcode => 0xb8,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'invokevirtual',	opcode => 0xb6,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ior',			opcode => 0x80,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'irem',		opcode => 0x70,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ireturn',		opcode => 0xac,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ishl',		opcode => 0x78,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ishr',		opcode => 0x7a,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'istore',		opcode => 0x36,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'istore_0',	opcode => 0x3b,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'istore_1',	opcode => 0x3c,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'istore_2',	opcode => 0x3d,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'istore_3',	opcode => 0x3e,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'isub',		opcode => 0x64,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'iushr',		opcode => 0x7c,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ixor',		opcode => 0x82,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'jsr',			opcode => 0xa8,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'jsr_w',		opcode => 0xc9,	length => 4 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'l2d',			opcode => 0x8a,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'l2f',			opcode => 0x89,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'l2i',			opcode => 0x88,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ladd',		opcode => 0x61,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'laload',		opcode => 0x2f,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'land',		opcode => 0x7f,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lastore',		opcode => 0x50,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lcmp',		opcode => 0x94,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lconst_0',	opcode => 0x09,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lconst_1',	opcode => 0x0a,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ldc',			opcode => 0x12,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ldc_w',		opcode => 0x13,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ldc2_w',		opcode => 0x14,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ldiv',		opcode => 0x6d,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lload',		opcode => 0x16,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lload_0',		opcode => 0x1e,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lload_1',		opcode => 0x1f,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lload_2',		opcode => 0x20,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lload_3',		opcode => 0x21,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lmul',		opcode => 0x69,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lneg',		opcode => 0x75,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lookupswitch',	opcode => 0xab,	length => -1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lor',			opcode => 0x81,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lrem',		opcode => 0x71,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lreturn',		opcode => 0xad,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lshl',		opcode => 0x79,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lshr',		opcode => 0x7b,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lstore',		opcode => 0x37,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lstore_0',	opcode => 0x3f,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lstore_1',	opcode => 0x40,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lstore_2',	opcode => 0x41,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lstore_3',	opcode => 0x42,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lsub',		opcode => 0x65,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lushr',		opcode => 0x7d,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'lxor',		opcode => 0x83,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'monitorenter',	opcode => 0xc2,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'monitorexit',	opcode => 0xc3,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'multianewarray',	opcode => 0xc5,	length => 3 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'new',			opcode => 0xbb,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'newarray',	opcode => 0xbc,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'nop',			opcode => 0x00,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'pop',			opcode => 0x57,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'pop2',		opcode => 0x58,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'putfield',	opcode => 0xb5,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'putstatic',	opcode => 0xb3,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'ret',			opcode => 0xa9,	length => 1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'return',		opcode => 0xb1,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'saload',		opcode => 0x35,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'sastore',		opcode => 0x56,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'sipush',		opcode => 0x11,	length => 2 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'swap',		opcode => 0x5f,	length => 0 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'tableswitch',	opcode => 0xaa,	length => -1 ),
		Java::VM::Bytecode::Opcode->new( mnemonic => 'wide',		opcode => 0xc4,	length => 0 )
	);
	
	my %code_hash;
	for(@{$opcodes}) {
		$code_hash{$_->opcode} = $_;
	}
	return \%code_hash;
}

no Moose;

__PACKAGE__->meta->make_immutable;
