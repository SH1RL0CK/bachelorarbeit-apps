import React from "react";
import { StyleSheet, View } from "react-native";
import { IconButton, useTheme } from "react-native-paper";

interface StarRatingProps {
    rating: number;
    onRatingChanged?: (rating: number) => void;
    maxRating?: number;
    starSize?: number;
    isEditable?: boolean;
}

export const StarRating: React.FC<StarRatingProps> = ({
    rating,
    onRatingChanged,
    maxRating = 5,
    starSize = 24,
    isEditable = true,
}) => {
    const theme = useTheme();

    const activeColor = "#FFC107"; // Amber color like Flutter
    const inactiveColor = theme.colors.outline;

    return (
        <View style={styles.container}>
            {Array.from({ length: maxRating }, (_, index) => (
                <IconButton
                    key={index}
                    icon={index < rating ? "star" : "star-outline"}
                    iconColor={index < rating ? activeColor : inactiveColor}
                    size={starSize}
                    onPress={
                        isEditable && onRatingChanged
                            ? () => onRatingChanged(index + 1)
                            : undefined
                    }
                    style={[styles.star, !isEditable && styles.nonEditable]}
                />
            ))}
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flexDirection: "row",
        alignItems: "center",
    },
    star: {
        margin: 0,
        marginHorizontal: 2,
    },
    nonEditable: {
        // Reduce touch target for non-editable stars
        padding: 0,
    },
});
