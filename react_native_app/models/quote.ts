export interface Quote {
    id?: string;
    text: string;
    character?: string;
    movie: string;
    year?: number;
    rating: number;
    createdAt?: Date;
}

export const createQuote = (
    data: Omit<Quote, "rating"> & { rating?: number }
): Quote => ({
    rating: 1,
    ...data,
    id: data.id || generateId(),
    createdAt: data.createdAt || new Date(),
});

export const generateId = (): string => {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
};
