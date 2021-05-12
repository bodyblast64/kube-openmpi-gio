KUBE_OPENMPI_VERSION ?= 0.7.2
REPOSITORY ?= umwrg/kube-openmpi

OPENMPI_VERSION ?= 4.0.3

# Args for SSH Uer embedded in container images
SSH_USER ?= openmpi
SSH_UID ?= 1000
SSH_GID ?= 1000

# Args for Base Image
UBUNTU_REPOSITORY ?= ubuntu
UBUNTU_TAG ?= 20.04
UBUNTU_IMAGE ?= $(REPOSITORY):$(OPENMPI_VERSION)-$(UBUNTU_TAG)-$(KUBE_OPENMPI_VERSION)
UBUNTU_ALIAS ?= $(REPOSITORY):$(KUBE_OPENMPI_VERSION)

.PHONY: build
build: ubuntu_image

ubuntu_image:
	docker build \
		--build-arg UBUNTU_BASED_BASE_IMAGE=$(UBUNTU_REPOSITORY):$(UBUNTU_TAG) \
		--build-arg OPENMPI_VERSION=$(OPENMPI_VERSION) \
		--build-arg WITH_CUDA="false" \
		--build-arg SSH_USER=$(SSH_USER) \
		--build-arg SSH_UID=$(SSH_UID) \
		--build-arg SSH_GID=$(SSH_GID) \
		-t $(UBUNTU_IMAGE) --no-cache \
		. && \
		docker tag $(UBUNTU_IMAGE) $(UBUNTU_ALIAS)

publish:
	docker push $(UBUNTU_IMAGE) && docker push $(UBUNTU_ALIAS)
