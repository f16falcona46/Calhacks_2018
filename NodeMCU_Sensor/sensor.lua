i2c_id  = 0
sda = 2
scl = 1

-- initialize i2c, set pin1 as sda, set pin2 as scl
i2c.setup(i2c_id, sda, scl, i2c.SLOW)

-- user defined function: read from reg_addr content of dev_addr
function read_reg(dev_addr, reg_addr)
	i2c.start(i2c_id)
	i2c.address(i2c_id, dev_addr, i2c.TRANSMITTER)
	i2c.write(i2c_id, reg_addr)
	i2c.stop(i2c_id)
	i2c.start(i2c_id)
	i2c.address(i2c_id, dev_addr, i2c.RECEIVER)
	c = i2c.read(i2c_id, 1)
	i2c.stop(i2c_id)
	return c
end

function write_reg(dev_addr, reg_addr, data)
	i2c.start(i2c_id)
	i2c.address(i2c_id, dev_addr, i2c.TRANSMITTER)
	i2c.write(i2c_id, reg_addr, data)
	i2c.stop(i2c_id)
end

function read_total_mag()
	xh = string.byte(read_reg(BNO055_ADDRESS, MAG_DATA_X_MSB))
	xl = string.byte(read_reg(BNO055_ADDRESS, MAG_DATA_X_LSB))
	x = xh * 256 + xl
	if x > 32767 then
		x = -(65536 - x)
	end
	x = x / 16
	yh = string.byte(read_reg(BNO055_ADDRESS, MAG_DATA_Y_MSB))
	yl = string.byte(read_reg(BNO055_ADDRESS, MAG_DATA_Y_LSB))
	y = yh * 256 + yl
	if y > 32767 then
		y = -(65536 - y)
	end
	y = y / 16
	zh = string.byte(read_reg(BNO055_ADDRESS, MAG_DATA_Z_MSB))
	zl = string.byte(read_reg(BNO055_ADDRESS, MAG_DATA_Z_LSB))
	z = zh * 256 + zl
	if z > 32767 then
		z = -(65536 - z)
	end
	z = z / 16
	return x*x + y*y + z*z
end

--registers
MAG_DATA_X_LSB = 0x0E
MAG_DATA_X_MSB = 0x0F
MAG_DATA_Y_LSB = 0x10
MAG_DATA_Y_MSB = 0x11
MAG_DATA_Z_LSB = 0x12
MAG_DATA_Z_MSB = 0x13
OPR_MODE = 0x3D

--constants
MAGONLY = 0x02

BNO055_ADDRESS_A = 0x28
BNO055_ADDRESS = BNO055_ADDRESS_A

write_reg(BNO055_ADDRESS, OPR_MODE, MAGONLY)

tmr.delay(20)