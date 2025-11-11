import 'package:flutter/material.dart';

class RepresentativeDetail extends StatelessWidget {
  const RepresentativeDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header icon + name + rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.apartment, color: Colors.blue, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saigon Tourist',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Icon(Icons.star_half, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        const Text('4.8 (2,637 đánh giá)'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('156', 'Tours'),
              _buildStatItem('15', 'Năm kinh nghiệm'),
              _buildStatItem('98%', 'Hài lòng'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Liên hệ'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Theo dõi'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Giới thiệu
          Text(
            'Giới thiệu',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Saigon Tourist là công ty du lịch hàng đầu Việt Nam với hơn 15 năm kinh nghiệm. '
            'Chúng tôi cam kết mang đến những chuyến đi an toàn, chất lượng và đáp ứng nhu cầu khách hàng.',
          ),
          const SizedBox(height: 8),
          const Text('📍 45 Lê Thánh Tôn, Q1, TP.HCM'),
          const Text('📧 info@saigontourist.net'),
          const Text('🌐 www.saigontourist.net'),
          const SizedBox(height: 16),

          // Dịch vụ
          Text(
            'Dịch vụ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(Icons.public, 'Du lịch quốc tế'),
              _buildServiceItem(Icons.local_florist, 'Du lịch trong nước'),
              _buildServiceItem(Icons.group, 'Đặt khách sạn'),
              _buildServiceItem(Icons.house, 'Thuê ô tô'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildServiceItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue[50],
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
