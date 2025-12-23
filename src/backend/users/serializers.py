from django.contrib.auth import get_user_model
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    """Serializer for User model"""

    class Meta:
        model = User
        fields = ["id", "username", "email", "first_name", "last_name", "role"]
        read_only_fields = ["id"]


class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    """Custom JWT serializer to include user role in token response"""

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)

        # Add custom claims to token
        token['role'] = user.role
        token['email'] = user.email
        token['username'] = user.username

        return token

    def validate(self, attrs):
        data = super().validate(attrs)

        # Add extra responses
        data['role'] = self.user.role
        data['email'] = self.user.email
        data['username'] = self.user.username
        data['user_id'] = self.user.id

        return data


class UserRegistrationSerializer(serializers.ModelSerializer):
    """Serializer for user registration"""

    password = serializers.CharField(write_only=True, min_length=8)
    password_confirm = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = ["username", "email", "password", "password_confirm", "first_name", "last_name", "role"]

    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError({"password": "Passwords don't match"})
        return attrs

    def create(self, validated_data):
        validated_data.pop('password_confirm')
        user = User.objects.create_user(**validated_data)
        return user
