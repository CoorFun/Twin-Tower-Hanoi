swap (N, A, B) {
	/* consolidate top N-1 disks from piles B and A onto pile A */
	consolidate (N - 1, B, A)
	move (1, B, C)
	double_hanoi (N - 1, A, C)
	move (1, A, B)
	double_hanoi (N - 1, C, B)
	/* distribute 2(N-1) disks on pile B to piles A and B */
	distribute (N - 1, B, A)
}

consolidate (n, src, dst) {
	if n == 1 {
		move (1, src, dst)
	} else {
		consolidate (n - 1, src, dst) /* head recursion */
		double_hanoi (n - 1, dst, tmp)
		move (1, src, dst)
		double_hanoi (n - 1, tmp, dst)
	}
}

distribute (n, src, dst) {
	if n == 1 {
		move (1, src, dst)
	} else {
		double_hanoi (n - 1, src, tmp)
		move (1, src, dst)
		double_hanoi (n - 1, tmp, src)
		distribute (n - 1, src, dst) /* tail recursion */
	}
}

/* move n pairs from src to dst */
double_hanoi (n, src, dst) {
	double_hanoi (n - 1, src, tmp) /* tmp = spare pile */
	move (1, src, dst)
	move (1, src, dst)
	double_hanoi (n - 1, tmp, dst)
}