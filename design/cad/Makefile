SCAD ?= openscad
OUT_DIR ?= output

QUALITY_ORDER ?= 5

printables: \
  assemblies/parts/10mm_ball_caster_base.stl \
  assemblies/parts/10mm_ball_caster_support.stl \
  assemblies/parts/10mm_ball_caster_yoke.stl \
  assemblies/parts/50mm_ball_caster_base.stl \
  assemblies/parts/50mm_ball_caster_spring_seat.stl \
  assemblies/parts/50mm_ball_caster_support.stl \
  assemblies/parts/50mm_ball_caster_yoke.stl \
  assemblies/parts/base_chassis.partA.stl \
  assemblies/parts/base_chassis.partB.stl \
  assemblies/parts/bumper.partA.stl \
  assemblies/parts/bumper.partB.stl \
  assemblies/parts/chassis_cover.partA.stl \
  assemblies/parts/chassis_cover.partB.stl \
  assemblies/parts/hcs04_sonar_bracket.stl \
  assemblies/parts/mr08d_motor_base_bracket.stl \
  assemblies/parts/mr08d_motor_base_support.stl \
  assemblies/parts/mr08d_motor_front_cap.stl \
  assemblies/parts/mr08d_motor_rear_cap.stl \
  assemblies/parts/pole_plug.partA.stl \
  assemblies/parts/pole_plug.partB.stl \
  assemblies/parts/wheel_block_frame.stl \
  assemblies/parts/wheel_suspension_arm.partA.stl \
  assemblies/parts/wheel_suspension_arm.partB.stl \
  assemblies/parts/wheel_suspension_frame.partA.stl \
  assemblies/parts/wheel_suspension_frame.partB.stl

cuttables: \
	assemblies/parts/chassis_bay.svg \
  assemblies/parts/board_support.svg

%.stl: %.scad
	mkdir -p $(OUT_DIR)/$(@D)
	$(SCAD) -D "quality_order=$(QUALITY_ORDER)" -o $(OUT_DIR)/$@ $<

%.svg: %.scad
	mkdir -p $(OUT_DIR)/$(@D)
	$(SCAD) -D "quality_order=$(QUALITY_ORDER)" -o $(OUT_DIR)/$@ $<


clean:
	rm -rf $(OUT_DIR)
