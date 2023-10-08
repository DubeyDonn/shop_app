import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../provider/shipping_info.dart';
import 'checkout_screen.dart';

class AddShippingAddressScreen extends StatefulWidget {
  static const routeName = '/add-shipping-address';

  const AddShippingAddressScreen({super.key});

  @override
  _AddShippingAddressScreenState createState() =>
      _AddShippingAddressScreenState();
}

class _AddShippingAddressScreenState extends State<AddShippingAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _mobileNumberController = TextEditingController();

  var _initState = true;
  var _isLoading = false;

  var _newShippingAddress = ShippingInfo(
    id: '',
    fullName: '',
    address: '',
    city: '',
    mobileNumber: '',
  );

  @override
  void didChangeDependencies() {
    if (_initState) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        String shippingAddressId =
            ModalRoute.of(context)!.settings.arguments as String;
        if (shippingAddressId != '') {
          // _newProduct =
          //     Provider.of<ProductsProvider>(context).findById(productId);

          _newShippingAddress = Provider.of<ShippingInfoProvider>(context)
              .findById(shippingAddressId);
          // _initValues = {
          //   'title': _newProduct.title,
          //   'description': _newProduct.description,
          //   'price': _newProduct.price.toString(),
          //   'imageUrl': '',
          // };

          // _imageUrlController.text = _newProduct.imageUrl;

          _fullNameController.text = _newShippingAddress.fullName;
          _addressController.text = _newShippingAddress.address;
          _cityController.text = _newShippingAddress.city;
          _mobileNumberController.text = _newShippingAddress.mobileNumber;
        }
      }
    }

    _initState = false;

    super.didChangeDependencies();
  }

  Future<void> _saveForm(BuildContext context) async {
    var cart = Provider.of<Cart>(context, listen: false);

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_newShippingAddress.id != '') {
      try {
        await Provider.of<ShippingInfoProvider>(context, listen: false)
            .editShippingInfo(
          _newShippingAddress.id,
          _fullNameController.text,
          _addressController.text,
          _cityController.text,
          _mobileNumberController.text,
        );

        // Clear the form fields
        _fullNameController.clear();
        _addressController.clear();
        _cityController.clear();
        _mobileNumberController.clear();
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(CheckoutScreen.routeName, arguments: {
          'cart': cart.items.values.toList(),
          'totalAmount': cart.totalAmount
        });
      }
    } else {
      try {
        await Provider.of<ShippingInfoProvider>(context, listen: false)
            .addShippingInfo(
          _fullNameController.text,
          _addressController.text,
          _cityController.text,
          _mobileNumberController.text,
        );

        _fullNameController.clear();
        _addressController.clear();
        _cityController.clear();
        _mobileNumberController.clear();
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();

        Navigator.of(context).pushNamed(CheckoutScreen.routeName, arguments: {
          'cart': cart.items.values.toList(),
          'totalAmount': cart.totalAmount
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ModalRoute.of(context)!.settings.arguments == null
            ? const Text('Add Shipping Address')
            : const Text('Edit Shipping Address'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm(context);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  // Add validation here
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  // Add validation here
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                  // Add validation here
                ),
                TextFormField(
                  controller: _mobileNumberController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    _saveForm(context);
                  },
                  // Add validation here
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _saveForm(context);
                    },
                    child: const Text('Save Shipping Info'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
