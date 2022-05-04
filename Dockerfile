FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake
RUN git clone https://github.com/richgel999/fpng.git
WORKDIR /fpng
RUN rm -f example.png
RUN cmake -DCMAKE_C_COMPILER=afl-gcc -DCMAKE_CXX_COMPILER=afl-g++ .
RUN make
RUN make install
RUN cp ./bin/fpng_test /fpng_fuzz
RUN mkdir /png-corpus
RUN wget https://file-examples.com/wp-content/uploads/2017/10/file_example_PNG_500kB.png
RUN wget https://file-examples.com/wp-content/uploads/2017/10/file_example_PNG_1MB.png
RUN wget https://people.sc.fsu.edu/~jburkardt/data/png/ajou_logo.png
RUN wget https://people.sc.fsu.edu/~jburkardt/data/png/all_gray.png
RUN wget https://people.sc.fsu.edu/~jburkardt/data/png/brain.png
RUN wget https://people.sc.fsu.edu/~jburkardt/data/png/coins.png
RUN wget https://people.sc.fsu.edu/~jburkardt/data/png/dla.png
RUN mv *.png /png-corpus

# Fuzz
ENTRYPOINT ["afl-fuzz", "-i", "/png-corpus", "-o", "/out"]
CMD ["/fpng_fuzz", "@@"]
