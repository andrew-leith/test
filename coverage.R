args <- commandArgs(TRUE)
data.file <- as.character(args[1])
reference.file <- as.character(args[2])


library(Biostrings)

#reference.genome <- readDNAStringSet("hiv_reference.fasta")
reference.genome <- readDNAStringSet(reference.file)

#full.result <- read.table("output_new.txt")
full.result <- read.table(data.file)


seq <- as.data.frame(reference.genome)[1,1]
seq.split <- strsplit(seq, "")[[1]]

coverage.table <- cbind(full.result, seq.split)
colnames(coverage.table) <- c("name", "position", "reads", "base")

pdf("coverage.pdf")
barplot(coverage.table$reads, xlab = "Position", ylab = "Reads Covering Position", main = "Coverage")
dev.off()

t.table <- subset(coverage.table, coverage.table$base == "T")
c.table <- subset(coverage.table, coverage.table$base == "C")
g.table <- subset(coverage.table, coverage.table$base == "G")
a.table <- subset(coverage.table, coverage.table$base == "A")
plot(density(t.table$reads))
lines(density(c.table$reads), col = "red")
lines(density(g.table$reads), col = "blue")
lines(density(a.table$reads), col = "green")

options(warn=-1)
tc.test <- ks.test(t.table$reads, c.table$reads)
tg.test <- ks.test(t.table$reads, g.table$reads)
ta.test <- ks.test(t.table$reads, a.table$reads)
gc.test <- ks.test(g.table$reads, c.table$reads)
ta.test <- ks.test(t.table$reads, a.table$reads)
ca.test <- ks.test(c.table$reads, a.table$reads)
test.vector <- c(tc.test$p.value, tg.test$p.value, ta.test$p.value, gc.test$p.value, ta.test$p.value, ca.test$p.value)
options(warn=0)
corrected.test.vector <- p.adjust(test.vector, method = "bonferroni")
significant.vector <- corrected.test.vector < .05

comparison.vector <- c("T v. C", "T v. G", "T v. A", "G v. C", "G v. A", "C v. A")

nucleotide.data <- data.frame(comparison.vector, test.vector, corrected.test.vector, significant.vector)
colnames(nucleotide.data) <- c("Comparison", "p-value", "Adjusted p-value", "Difference in coverage")

write.table(nucleotide.data, "nucleotide_coverage_table.txt", sep = "\t", quote = F, row.names = F)

\documentclass{article}

\begin{document}

Hello R world. This is my first LaTeX document.

<<echo = TRUE, message = FALSE>>=

x <- rnorm(1000)
plot(x)

@

\end{document}
