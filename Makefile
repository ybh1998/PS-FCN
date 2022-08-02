VENV := /tmp/envs/PS-FCN
PYTHON:= $(VENV)/bin/python3
SQUASHFS_MOUNT := mkdir -p $(VENV); squashfuse venv.sqsh $(VENV)
SQUASHFS_UMOUNT := fusermount -q -u $(VENV); rm -rf $(VENV)
SQUASHFS := $(SQUASHFS_UMOUNT); $(SQUASHFS_MOUNT)

venv.sqsh: environment.yml requirements.txt
	$(SQUASHFS_UMOUNT)
	rm -rf venv.sqsh
	mkdir -p $(VENV)
	conda env create -p $(VENV) -f environment.yml
	$(VENV)/bin/pip install -r requirements.txt
	mksquashfs $(VENV) venv.sqsh -all-root
	rm -rf $(VENV)

xxx: venv.sqsh
	$(SQUASHFS)
	$(PYTHON) eval/run_model.py --retrain data/models/PS-FCN_B_S_32.pth.tar --in_img_num 96
