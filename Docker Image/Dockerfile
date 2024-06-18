# Seleccion de la imagen Ubuntu
FROM ubuntu:20.04

# Evitar prompts durante la construccion
ENV DEBIAN_FRONTEND=noninteractive

# Instalaccion de herramientas base y bioinformaticas
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    vim \
    python3 \
    python3-pip \
    git \
    unzip \
    default-jdk \
    fastqc \
    hisat2 \
    samtools \
    stringtie \
    bowtie2 \
    bwa \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/*



# Descarga e instalacion de SRA Toolkit
RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz \
    && tar -xzf sratoolkit.current-ubuntu64.tar.gz -C /opt/ \
    && rm sratoolkit.current-ubuntu64.tar.gz

# Configuracion en variables del sistema de SRA Toolkit
ENV PATH="/opt/sratoolkit.3.1.1-ubuntu64/bin:$PATH"

# Descarga y unzip de Trimmomatic
RUN wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip \
    && unzip Trimmomatic-0.39.zip -d /opt/trimmomatic \
    && rm Trimmomatic-0.39.zip

# crear un archivo wrapper script para Trimmomatic
RUN echo '#!/bin/bash\njava -jar /opt/trimmomatic/Trimmomatic-0.39/trimmomatic-0.39.jar "$@"' > /usr/local/bin/trimmomatic \
    && chmod +x /usr/local/bin/trimmomatic

# configutacion del usuario Linux
RUN useradd -m -s /bin/bash bioinstation \
    && echo 'bioinstation:bioinstation' | chpasswd \
    && adduser bioinstation sudo \
    && echo 'bioinstation ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Set non-root user as default
USER bioinstation
WORKDIR /home/bioinstation

# Keep the container running
CMD ["tail", "-f", "/dev/null"]
