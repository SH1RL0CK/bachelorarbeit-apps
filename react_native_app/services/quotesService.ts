import AsyncStorage from "@react-native-async-storage/async-storage";
import { Quote } from "../models/quote";

class QuotesService {
    private static readonly QUOTES_KEY = "quotes";

    async getQuotes(): Promise<Quote[]> {
        try {
            const quotesJson = await AsyncStorage.getItem(
                QuotesService.QUOTES_KEY
            );
            if (!quotesJson) return [];

            const quotes = JSON.parse(quotesJson) as Quote[];
            return quotes.map((quote) => ({
                ...quote,
                createdAt: quote.createdAt
                    ? new Date(quote.createdAt)
                    : undefined,
            }));
        } catch (error) {
            console.error("Error getting quotes:", error);
            return [];
        }
    }

    async addQuote(quote: Quote): Promise<void> {
        try {
            const quotes = await this.getQuotes();
            quotes.push(quote);
            await AsyncStorage.setItem(
                QuotesService.QUOTES_KEY,
                JSON.stringify(quotes)
            );
        } catch (error) {
            console.error("Error adding quote:", error);
            throw error;
        }
    }

    async updateQuote(quote: Quote): Promise<void> {
        try {
            const quotes = await this.getQuotes();
            const index = quotes.findIndex((q) => q.id === quote.id);
            if (index !== -1) {
                quotes[index] = quote;
                await AsyncStorage.setItem(
                    QuotesService.QUOTES_KEY,
                    JSON.stringify(quotes)
                );
            }
        } catch (error) {
            console.error("Error updating quote:", error);
            throw error;
        }
    }

    async deleteQuote(id: string): Promise<void> {
        try {
            const quotes = await this.getQuotes();
            const filteredQuotes = quotes.filter((q) => q.id !== id);
            await AsyncStorage.setItem(
                QuotesService.QUOTES_KEY,
                JSON.stringify(filteredQuotes)
            );
        } catch (error) {
            console.error("Error deleting quote:", error);
            throw error;
        }
    }

    async getRandomQuote(): Promise<Quote | null> {
        try {
            const quotes = await this.getQuotes();
            if (quotes.length === 0) return null;

            const randomIndex = Math.floor(Math.random() * quotes.length);
            return quotes[randomIndex];
        } catch (error) {
            console.error("Error getting random quote:", error);
            return null;
        }
    }
}

export const quotesService = new QuotesService();
